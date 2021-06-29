### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 67d16d90-d678-11eb-18fa-c1977cd50112
using HTTP, CSV, DataFrames, HypertextLiteral

# ╔═╡ fa5acdad-3ecd-4b8e-ab7e-b440b28477d6
@bind windowWidth @htl("""
	<div>
	<script>
		var div = currentScript.parentElement
		div.value = window.innerWidth
	</script>
	</div>
""")

# ╔═╡ 1314a84d-f43f-442d-98be-b3ede07b3e29
begin
	cellWidth = min(1000, windowWidth*0.95)
	@htl("""
		<style>
			pluto-notebook {
				margin: auto;
				width: $(cellWidth)px;
			}
		</style>
	""")
end

# ╔═╡ 342f37db-d60c-4bc4-9216-4b87adddec89
function read_daily_volume_data(year::Integer)
	BASE_URL = "http://markets.cboe.com/us/equities/market_statistics/historical_market_volume"
	url = "$(BASE_URL)/market_history_$(year).csv-dl"
	CSV.File(HTTP.get(url).body; normalizenames=true) |> DataFrame
end

# ╔═╡ 7615b8c4-4f6a-4704-8fda-24674562d5ed
df = read_daily_volume_data(2021);

# ╔═╡ 71e0e66f-acbb-424a-be5c-6f6569995ffc
describe(df)

# ╔═╡ Cell order:
# ╠═67d16d90-d678-11eb-18fa-c1977cd50112
# ╟─fa5acdad-3ecd-4b8e-ab7e-b440b28477d6
# ╟─1314a84d-f43f-442d-98be-b3ede07b3e29
# ╠═7615b8c4-4f6a-4704-8fda-24674562d5ed
# ╠═71e0e66f-acbb-424a-be5c-6f6569995ffc
# ╟─342f37db-d60c-4bc4-9216-4b87adddec89
