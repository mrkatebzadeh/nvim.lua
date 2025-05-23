COMMENT = {}

COMMENT.setup = function()
	local status_ok, which_key = pcall(require, "which-key")
	if not status_ok then
		return
	end

	local K = vim.keymap.set
	-- K("n", "K", vim.lsp.buf.hover, {})

	local call = require("Comment.api").call

	K("n", "<leader>/", call("toggle.linewise.current", "g@$"), { expr = true, desc = "Comment toggle current line" })

	K(
		"x",
		"<leader>/",
		'<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
		{ desc = "Comment toggle linewise (visual)" }
	)

	K(
		"x",
		"<leader>/",
		'<ESC><CMD>lua require("Comment.api").locked("toggle.blockwise")(vim.fn.visualmode())<CR>',
		{ desc = "Comment toggle blockwise (visual)" }
	)

	local mappings = {
		{ "<leader>/", group = "Window", mode = { "v", "n" }, nowait = true, remap = false },
	}
	which_key.add(mappings)
end

return COMMENT
