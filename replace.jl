### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ dece5f90-d6df-11eb-3b7f-f3dce8a7c686
md"# replace"

# ╔═╡ 62134f84-d7b1-455d-a3c3-4412ec4e7e06
md"""
- Replace `missing` values with `NaN`
"""

# ╔═╡ eed959ba-9c6d-4067-abbd-4ec01438e22a
replace([1.0, missing, 2.0, missing], missing=>NaN)

# ╔═╡ 351460e0-11aa-4994-88be-d3372883d642
md"""
- Replace `.` with `-` in a string
"""

# ╔═╡ cc3b095b-a622-4f96-8a83-4eb57e0fc4dc
begin
	date_str = "2021.06.26"
	res1 = replace(date_str, '.' => '-')
	res2 = replace(date_str, "." => "-")
	(res1, res2)
end

# ╔═╡ Cell order:
# ╟─dece5f90-d6df-11eb-3b7f-f3dce8a7c686
# ╟─62134f84-d7b1-455d-a3c3-4412ec4e7e06
# ╠═eed959ba-9c6d-4067-abbd-4ec01438e22a
# ╟─351460e0-11aa-4994-88be-d3372883d642
# ╠═cc3b095b-a622-4f96-8a83-4eb57e0fc4dc
