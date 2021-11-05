local lain = require("lain")
return lain.util.quake({
  app = "kitty",
  argname = '--class %s',
  name = 'epic',
  height = 0.55,
  followtag = true,
  visible = false
})
