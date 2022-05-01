const express = require("express");

const PORT = process.env.PORT || 4000;

const app = express();

app.use("/reference", express.static("reference"));

app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
