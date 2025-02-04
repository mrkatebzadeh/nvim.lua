D_DEBUG = {}

D_DEBUG.setup = function()
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    return
  end

  local mappings = {
    {
      mode = { "v", "n" },
      { "<leader>d", group = "Debug", nowait = true, remap = false },
      { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint", nowait = true, remap = false },
      { "<leader>dc", ":DapContinue<CR>", desc = "Continue", nowait = true, remap = false },
      { "<leader>di", ":DapStepInto<CR>", desc = "Step Into", nowait = true, remap = false },
      { "<leader>do", ":DapStepOver<CR>", desc = "Step Over", nowait = true, remap = false },
      { "<leader>dq", ":DapTerminate<CR>", desc = "Terminate", nowait = true, remap = false },
      { "<leader>du", ":DapStepOut<CR>", desc = "Step Out", nowait = true, remap = false },
    },
  }

  which_key.add(mappings)

end

return D_DEBUG
