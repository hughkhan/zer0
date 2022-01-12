const { Pool } = require("pg");
const { CONN } = process.env;

const pool = new Pool({ connectionString: CONN });

module.exports = {
  clientpg: () => pool.connect()
};

