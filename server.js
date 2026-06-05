const express = require("express");
const cors = require("cors");
const { exec } = require("child_process");
const fs = require("fs");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());

// Path to your compiled compiler binary
const COMPILER_PATH = path.join(__dirname, "compiler");

app.post("/compile", (req, res) => {
    const code = req.body.code;
    const inputPath = path.join(__dirname, "input.txt");

    // 1. Write the code to a file
    fs.writeFileSync(inputPath, code);

    // 2. Execute the C compiler
    exec(`${COMPILER_PATH} < ${inputPath}`, (err, stdout, stderr) => {
        if (err && !stdout) {
            return res.json([{ type: "error", value: stderr || "Execution failed" }]);
        }

        // 3. Process the lines into a JSON array
        const lines = stdout.trim().split("\n");
        const results = lines
            .filter(line => line.trim().startsWith('{'))
            .map(line => {
                try { return JSON.parse(line); } 
                catch(e) { return { type: "debug", value: line }; }
            });

        res.json(results);
    });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`✅ Backend server running on http://localhost:${PORT}`);
});