extends VoxelGeneratorScript


# مقدار سایز Chunk و بیشترین ارتفاع
const MAX_HEIGHT := 2

func _generate_block(buffer: VoxelBuffer, origin: Vector3i, lod: int) -> void:
	var size := buffer.get_size()

	for x in range(size.x):
		for z in range(size.z):
			# ارتفاع سطح = یک نویز ساده
			var wx := x + origin.x
			var wz := z + origin.z
			var height := int(simple_noise(wx, wz))

			# clamp
			height = clamp(height, 0, MAX_HEIGHT)

			# پر کردن ستون بلوک‌ها
			for y in range(size.y):
				var wy := y + origin.y

				if wy <= height:
					buffer.set_voxel(1, x, y, z, 0) # بلاک id=1
				else:
					buffer.set_voxel(0, x, y, z, 0) # هوا
var noise := FastNoiseLite.new()

func _ready():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.01

func simple_noise(x, z):
	# نویز 2بعدی → ارتفاع
	var n := noise.get_noise_2d(x, z)
	n = (n + 1.0) * 0.5  # 0..1
	return n * MAX_HEIGHT
