const mongoose = require("mongoose");


// Define the TODO Schema
const todoSchema = new mongoose.Schema({
  todotitle: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    default: "",
    trim: true,
  },
  isCompleted: {
    type: Boolean,
    default: false
  },
  priority: {
    type: String,
    enum: ["low", "medium", "high"],
    default: "medium",
  },
},
  { timestamps: true },
);

const Todos = mongoose.model('Todo', todoSchema);
module.exports = Todos;