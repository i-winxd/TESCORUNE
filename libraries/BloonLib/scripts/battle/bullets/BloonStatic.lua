local BloonSeeker, super = Class(BloonBase, "BloonStatic")

function BloonSeeker:init(x, y, bloon_type, health)
    super.init(self, x, y, bloon_type, health)
    self.object_path = "BloonStatic"
end


return BloonSeeker
