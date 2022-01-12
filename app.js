require("dotenv").config();
const db = require("./config/database");
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const Auth = require("./auth");

const app = express();

app.use(express.json({ limit: "50mb" }));

app.post("/register", async (req, res) => {
  try {
    const { first_name, last_name, email, password } = req.body;

    if (!(email && password && first_name && last_name)) {
      res.status(400).send("Supply values for first_name, last_name, email, password");
      return;
    }

    // check if user already exist
    const clientpg = await db.clientpg();
    let queryText ="select email from users where email = $1";
    let result = await clientpg.query(queryText, [email]);
    if (result.rowCount > 0){
      res.status(409).send("User Already Exists. Please Login");
      return;
    }

    //Encrypt user password
    encryptedPassword = await bcrypt.hash(password, 10);

    // Add user to the database
    queryText = "INSERT INTO users (name_first, name_last, email, password_hash) VALUES($1::VARCHAR, $2::VARCHAR, $3::VARCHAR, $4::VARCHAR)";
    result = await clientpg.query(queryText, [first_name, last_name, email, encryptedPassword]);

    console.log(result);

    // Create session jwt token
    const token = jwt.sign(
      { email: email },
      process.env.TOKEN_KEY,
      {
        expiresIn: "2h",
      }
    );

    let jsonStr = {};
    jsonStr["email"] = email;
    jsonStr["token"] = token;
  
    // return email and the session jwt token
    res.status(201).json(jsonStr);
  } catch (err) {
    console.log(err);
  }
});

app.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!(email && password)) {
      res.status(400).send("Please supply values for email and password");
      return;
    }

    let token = "";
    // check if user exists and if yes, check that the password matches
    const clientpg = await db.clientpg();
    let queryText ="select password_hash from users where email = $1";
    let result = await clientpg.query(queryText, [email]);
    if ((result.rowCount > 0) && (await bcrypt.compare(password, result.rows[0].password_hash))){
      // Create token
      token = jwt.sign(
        { email: email },
        process.env.TOKEN_KEY,
        {
          expiresIn: "2h",
        }
      );      
    }
    else{
      res.status(400).send("Invalid Credentials or User Does Not Exist");
      return;
    }

    let jsonStr = {};
    jsonStr["email"] = email;
    jsonStr["token"] = token;
  
    // return email and jwt token
    res.status(201).json(jsonStr);

  } catch (err) {
    console.log(err);
  }
});

app.post("/project/list", async (req, res) => {
  try {
    const { token } = req.body;
    let authorized = false;

    let email = Auth.isTokenValid(token);
    if (email == undefined){
      authorized = false;
    }
    else{
      authorized = true;
    }

    let jsonMain = {"projects":[]};

    const clientpg = await db.clientpg();
    let queryText = "";
    let result;

    if (authorized){
      queryText = "SELECT name, visibility, status, type FROM project WHERE visibility = 'PUBLIC' " + 
                    "UNION ALL " + 
                    "SELECT p.name, p.visibility, p.status, p.type " + 
                        "FROM project_x_users x " + 
                        "INNER JOIN users AS u ON x.users_id = u.id INNER JOIN project AS p ON x.project_id = p.id " +
                        "WHERE email = $1";
      result = await clientpg.query(queryText, [email]);
    }
    else {
      queryText = "SELECT name, visibility, status, type FROM project WHERE visibility = 'PUBLIC'";
      result = await clientpg.query(queryText);
    }


    if (result.rowCount > 0){
      for (let i = 0; i < result.rowCount; i++) {
        let jsonProject = {}
        jsonProject["name"] = result.rows[i]["name"];
        jsonProject["visibility"] = result.rows[i]["visibility"];
        jsonProject["status"] = result.rows[i]["status"];
        jsonProject["type"] = result.rows[i]["type"];
        jsonMain["projects"].push(jsonProject);
      }
    }

    // return the list of projects and their properties
    res.status(201).json(jsonMain);

  } catch (err) {
    console.log(err);
  }
});

app.post("/project/list/:email", async (req, res) => {
  try {
    const { token } = req.body;
    let authorized = false;

    let email = req.params.email;

    let email_x = Auth.isTokenValid(token);
    if (email_x == undefined){
      authorized = false;
    }
    else{
      if (email_x === email)
      authorized = true;
    }

    let jsonMain = {"projects":[]};

    const clientpg = await db.clientpg();
    let queryText ="SELECT p.name, p.visibility, p.status, p.type FROM project_x_users x INNER JOIN users AS u ON x.users_id = u.id INNER JOIN project AS p ON x.project_id = p.id WHERE email = $1";
    let result = await clientpg.query(queryText, [email]);

    if (result.rowCount > 0){
      for (let i = 0; i < result.rowCount; i++) {
        if ((result.rows[i]["visibility"] !== "PRIVATE") || authorized){
          let jsonProject = {}
          jsonProject["name"] = result.rows[i]["name"];
          jsonProject["visibility"] = result.rows[i]["visibility"];
          jsonProject["status"] = result.rows[i]["status"];
          jsonProject["type"] = result.rows[i]["type"];
          jsonMain["projects"].push(jsonProject);
        }
      }
    }

    // return the list of projects and their properties
    res.status(201).json(jsonMain);

  } catch (err) {
    console.log(err);
  }
});

app.all("/authtest", Auth.verifyToken, (req, res) => {
  const { email } = res;
  res.status(200).send("Welcome " + email);
});


// No url match
app.use("*", (req, res) => {
  res.status(404).json({
    success: "false",
    message: "Page not found",
    error: {
      statusCode: 404,
      message: "No such route on this service",
    },
  });
});

module.exports = app;
