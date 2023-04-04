
[Українська версія README](./README-uk.md)
<h1 align="center">Task Manager</h1>
<p align="center">
  A simple command-line task manager written in Bash.
</p>
<p>A simple command-line task manager written in Bash. The script allows you to:</p>
<ul>
  <li>display the list of tasks</li>
  <li>add a new task to the list</li>
  <li>edit an existing task</li>
  <li>remove a task from the list</li>
</ul>
<h2>Usage</h2>

<pre><code>$ ./tasks.sh [-h|--help] [-v|--verbose] [-f|--file &lt;task_file&gt;]</code></pre>

<h3>Options:</h3>
<ul>
  <li><code>-h, --help</code>: Display usage information</li>
  <li><code>-v, --verbose</code>: Enable verbose output</li>
  <li><code>-f, --file &lt;task_file&gt;</code>: Path to the task file (default: $HOME/.cache/tasks.txt)</li>
</ul>

<p>To add an alias for convenient use, add the following line to your .bashrc or .bash_profile file:</p>
<p><code>alias task='path/to/tasks.sh'</code></p>
<p>This will allow you to call the script by simply typing "task" in the terminal.</p>
<p><strong>Note:</strong> If a task starts with "!", it will be displayed in <span style="color: blue;">blue color</span>.</p>
