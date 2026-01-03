return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 6,
  nextobjectid = 16,
  properties = {},
  tilesets = {
    {
      name = "tesco_room",
      firstgid = 1,
      filename = "../tilesets/tesco_room.tsx"
    },
    {
      name = "castle",
      firstgid = 65,
      filename = "../tilesets/castle.tsx",
      exportfilename = "../tilesets/castle.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 0, 0,
        0, 0, 0, 0, 0, 0, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 87, 87, 87, 87, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "markers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 3,
          name = "spawn",
          type = "",
          shape = "point",
          x = 320.249,
          y = 341.82,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "entry",
          type = "",
          shape = "point",
          x = 321.079,
          y = 423.956,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "collision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 40,
          width = 40,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 320,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 360,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 320,
          width = 40,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 320,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 0,
          width = 40,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 0,
          width = 520,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "objects",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 12,
          name = "enemy",
          type = "",
          shape = "rectangle",
          x = 299.419,
          y = 188.245,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "tesco",
            ["encounter"] = "tesco"
          }
        },
        {
          id = 15,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 242.255,
          y = 472.811,
          width = 157.648,
          height = 40.0151,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "tesco_map_1",
            ["marker"] = "entry"
          }
        }
      }
    }
  }
}
