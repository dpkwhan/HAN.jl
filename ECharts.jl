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

# ╔═╡ e6ebbbc7-214d-48ad-ba9a-d654078c770a
using HypertextLiteral

# ╔═╡ 4ccd999d-02f1-43eb-890d-70a869146387
@bind screenWidth @htl("""
	<div>
	<script>
		var div = currentScript.parentElement
		div.value = screen.width
	</script>
	</div>
""")

# ╔═╡ 54cb3177-b3e8-4781-a451-a9e1449d9de1
begin
	cellWidth = min(1000, screenWidth*0.9)
	@htl("""
		<style>
			pluto-notebook {
				margin: auto;
				width: $(cellWidth)px;
			}
		</style>
	""")
end

# ╔═╡ dd415906-0220-44ff-b4e7-fbdccea0aab5
data = [
	Dict("time" => "2021-06-23T09:30:01.123", "qty"=>200, "price"=>12.34),
	Dict("time" => "2021-06-23T09:31:22.234", "qty"=>400, "price"=>12.37),
	Dict("time" => "2021-06-23T09:33:05.678", "qty"=>900, "price"=>12.43),
	Dict("time" => "2021-06-23T09:35:45.348", "qty"=>3200, "price"=>12.54),
]

# ╔═╡ 56b9ad55-fd84-4459-8e83-e6cba69c3f8e
@htl("""
<script src="https://cdn.jsdelivr.net/npm/echarts@5.1.2/dist/echarts.min.js"></script>
<script>
	const div = document.createElement("div");
	div.style.width = "$(cellWidth-10)px";
    div.style.height = "500px";
	
	var myChart = echarts.init(div);
	
	var data = $(data);
	let prices = [];
	var qtys = [];
	data.forEach(d => {
		prices.push([d.time, d.price]);
		qtys.push([d.time, d.qty])
	});
	
	var option = {
		title : {
			text: 'Price and Quantity',
			textStyle: {
				fontFamily: 'lato'
			}
		},
		tooltip : {
			trigger: 'axis'
		},
		calculable : true,
		xAxis : [
			{
				type: 'time',
				boundaryGap: false,
			}
		],
		yAxis : [
			{
				type: 'value',
				name: 'Price',
				min : 'dataMin',
				max : 'dataMax',
			}, {
				type: 'value',
				name: 'Shares',
				min : 'dataMin',
				max : 'dataMax',
			}
		],
		series : [
			{
				name:'Price',
				type:'line',
				smooth:true,
				data: prices
			}, {
				name:'Quantity',
				type:'line',
				smooth:true,
				yAxisIndex: 1,
				data: qtys
			}
		]
	}
	
	myChart.setOption(option);
	
	return div;
</script>
""")

# ╔═╡ e26e8398-79fe-4604-b944-2ec625944ac7
[(; zip(Symbol.(keys(d)), values(d))...) for d in data]

# ╔═╡ Cell order:
# ╠═e6ebbbc7-214d-48ad-ba9a-d654078c770a
# ╠═4ccd999d-02f1-43eb-890d-70a869146387
# ╠═54cb3177-b3e8-4781-a451-a9e1449d9de1
# ╠═dd415906-0220-44ff-b4e7-fbdccea0aab5
# ╟─56b9ad55-fd84-4459-8e83-e6cba69c3f8e
# ╠═e26e8398-79fe-4604-b944-2ec625944ac7
