const express = require("express");
const connectDB = require("./config/db");



const app = express();

// Middleware
app.use(express.json());

// Connect to MongoDB
connectDB();


app.use("/api/todos", require("./routes/todoRoutes")) 

const port = process.env.PORT || 3000;
app.listen(port, () =>
  console.log(`Server is listening at http://localhost:${port}`)
);
