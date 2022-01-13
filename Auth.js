const jwt = require("jsonwebtoken");
var config = process.env;

class Auth {

//    static TOKEN = config.TOKEN_KEY;

    static verifyToken (req, res, next) {
        const token =
          req.body.token || req.query.token || req.headers["x-access-token"];
      
        if (!token) {
          return res.status(403).send("A token is required for authentication");
        }
        try {
          const decoded = jwt.verify(token, config.TOKEN_KEY);
          res.email = decoded.email;
        } catch (err) {
          res.status(401).send("Invalid Token");
          return;
        }
        return next();
      };

    static isTokenValid (token) {
        try {
            const decoded = jwt.verify(token, config.TOKEN_KEY);
            return decoded.email;
          } catch (err) {
            return;
          }
    }

}

module.exports = Auth;
