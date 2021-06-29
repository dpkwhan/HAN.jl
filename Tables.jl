### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 5ec400e0-d60b-11eb-01f1-53cc15a5d0da
using HypertextLiteral

# ╔═╡ 4a0eebc7-265d-4757-a8f2-087a3db13bf6
books = [
	(name="Who Gets What & Why", year=2012, authors=["Alvin Roth"]),
	(name="Switch", year=2010, authors=["Chip Heath", "Dan Heath"]),
	(name="Governing The Commons", year=1990, authors=["Elinor Ostrom"])
]

# ╔═╡ 7b469922-4689-4391-bf23-b1058075dcb4
render_row(book) = @htl("""
	<tr>
		<td>$(book.name) ($(book.year))</td>
		<td>$(join(book.authors, " & "))</td>
	</tr>
""")

# ╔═╡ db60db26-a112-43d7-9396-8df6d6467d95
render_table(list) = @htl("""
	<table>
	<caption><h3>Selected Books</h3></caption>
	<thead>
	<tr><th>Book</th><th>Authors</th></tr>
	<tbody>
	$((render_row(b) for b in list))
	</tbody></table>
""")

# ╔═╡ e186d3c5-b3c3-4d27-90b4-c538776f1c6e
render_table(books)

# ╔═╡ Cell order:
# ╠═5ec400e0-d60b-11eb-01f1-53cc15a5d0da
# ╠═4a0eebc7-265d-4757-a8f2-087a3db13bf6
# ╠═7b469922-4689-4391-bf23-b1058075dcb4
# ╠═db60db26-a112-43d7-9396-8df6d6467d95
# ╠═e186d3c5-b3c3-4d27-90b4-c538776f1c6e
