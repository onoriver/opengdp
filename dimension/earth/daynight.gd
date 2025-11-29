extends DirectionalLight3D

const DAY_LENGTH := 600.0 # کل مدت روز، ثانیه
var rotation_speed := 360.0 / DAY_LENGTH

@onready var env := get_world_3d().environment

func _process(delta: float) -> void:
	# چرخش خورشید
	rotation_degrees.x -= rotation_speed * delta
	if rotation_degrees.x <= -360.0:
		rotation_degrees.x += 360.0

	# محاسبه زاویه فعلی (در بازه -360 تا 0)
	var angle = fmod(rotation_degrees.x, 360.0)
	if angle > 0:
		angle -= 360.0
	var x_rot_deg := rotation_degrees.x
	
	# در محدوده -180 تا 0 -> انرژی = 0
	if x_rot_deg >= -180.0 and x_rot_deg <= 0.0:
		light_energy = 1
	else:
		light_energy = 0
	# محاسبه‌ی انرژی آسمان بر اساس زاویه
	var energy := _calculate_sky_energy(angle)
	env.background_energy_multiplier = energy
		# 🔆 محاسبه‌ی انرژی خورشید بر اساس زاویه (افزوده‌شده)
func _calculate_sky_energy(angle: float) -> float:
	# طلوع: -15 تا 0 → 0 تا 1
	if angle >= -15 and angle <= 0:
		return lerp(1, 0, (angle + 15.0) /15.0)

	
	# روز: 0 تا -165 → 1
	elif angle < 0.0 and angle > -165.0:
		return 1.0
	# غروب: -165 تا -180 → 1 تا 0
	elif angle <= -165.0 and angle >= -180.0:
		return lerp(1.0, 0.0, (-165.0 - angle) / 15.0)

	# شب: -180 تا -360 → 0
	else:
		return 0.0
