const express = require("express");
const router = express.Router();
const Todos = require("../models/todo");
require('dotenv').config(); // Load environment variables from .env file
const Groq = require('groq-sdk');

const groq = new Groq({ apiKey: process.env.GROQ_API});

// Get All Todo
router.get("/", async (req, res) => {

  try {
    const todos = await Todos.find();
    res.json(todos);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


// POST: route to add a user
router.post("/create-todo", async (req, res) => {
  try {
    const todo = new Todos(req.body);
    await todo.save();

    res.status(201).json(todo);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
})

// PUT: UPDATE A TODO
router.put("/update-todo/:id", async (req, res) => {
  try {
    const updatedTodo = await Todos.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true } // return updated document
    );

    if (!updatedTodo) {
      return res.status(404).send("Todo not found");
    }

    res.status(201).json(updatedTodo);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


// DELETE:  Delete a todo
router.delete("/delete-todo/:id", async (req, res) => {
  try {
    const deletedTodo = await Todos.findByIdAndDelete(req.params.id
    );

    if (!deletedTodo) {
      return res.status(404).send("Todo not found");
    }

    res.ajson({ message: "Todo deleted successfully", deletedTodo });


  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});


router.get("/filter-todo", async (req, res) => {

  try {
    let query = req.query.by;
    let todoList;

    // CREATED DATE ASC 
    if (query === "createdAt_asc") {
      todoList = await Todos.find().sort({ createdAt: 1 });
    }

    // CREATED DATE DESC 
    else if (query === "createdAt_desc") {
      todoList = await Todos.find().sort({ createdAt: -1 });
    }

    // PRIORITY 
    else if (query === "priority") {
      todoList = await Todos.find().sort({ priority: 1 });
    }

    // COMPLETION FILTER
    else if (query === "completed") {
      todoList = await Todos.find().sort({
        isCompleted: -1,
      });
    }
    else {
      return res.status(400).json({ message: "Invalid filter type" });
    }
    return res.json(todoList)
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }

})


router.get("/ai-summary", async (req, res) => {

  try {

    let myTodos = await Todos.find();

    if (myTodos.length === 0) {
      return res.json({ message: "No todos available to summarize." });
    }

    let todointext = myTodos.map((t, index) => {
      return `${index + 1}. ${t.todotitle} | Priority: ${t.priority} | Descroption: ${t.description}  | Completed: ${t.isCompleted}`;
    }).join("\n");

    let prompt = `Summarize these todos: ${todointext}, 
 Give me:
- Total tasks
- Completed tasks
- Not completed tasks
- Count by priority (high, medium, low)
- A short 2 line suggestion
 `;


    const completion = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [
        {
          role: 'user',
          content: prompt,
        },

        {
          role: "system",
          content: "You are a helpful todo assistant."
        },]


    });

    console.log(completion.choices[0].message.content);

    let aiReply = completion.choices[0].message.content;

    res.status(200).json({
      summary: aiReply,
    })

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: error.message });
  }


})

module.exports = router;