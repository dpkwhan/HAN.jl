### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 295d0c40-d871-11eb-3aaa-2b04d2d668b3
md"""
# Digit Pattern
"""

# ╔═╡ 5c007783-19b1-472d-8d12-1f427ac363a9
md"""
!!! info "Problem"
	Begin with the 200-digit number ``98765432109876543\cdots\cdots76543210``, which repeats the digits 0-9 in reverse order. From the left, choose every third digit to form a new number. Repeat the same process with the new number and continue this process repeatedly until the result is a two-digit number. What is the resulting two-digit number?
"""

# ╔═╡ 40d5c166-7726-47c4-bf35-01475c4bff29
md"""
## Emulate the number
Instead of creating a huge number with 200 digits, we can store all digits of this number in an array. For example, we can represent 536 by ``[5, 3, 6]``. For the number ``9876543210``, we can use a step range function with step equal to ``-1``, *i.e.*

```julia
9:-1:0
```
which is repeated 20 times to get an array of 200 elements, *i.e.*
"""

# ╔═╡ 0b1d443c-b6f4-4701-8223-519f95888a29
numbers = repeat(9:-1:0, 20)

# ╔═╡ f7873d04-ca90-4fe5-bc07-9767b1593e38
md"""
## Algorithm
For a given array, do the following:
- Select all elements with index being a multiple of 3
- Save the resulting number from previous step
- Repeat steps 1 and 2 until the number of the elements in the array equals 2
"""

# ╔═╡ d68b05c4-ff14-4df3-b5fd-1661cc7777c3
md"""
## Implementation
This should be implemented as a recursive function. Below is one solution:
"""

# ╔═╡ 107fa4fe-1f8d-49fb-ba86-5b0812c9c983
function f(numbers::Vector{Int})
	num_digits = length(numbers)
	if num_digits == 2
		return numbers
	end
	
	idx = 3:3:num_digits
	return f(numbers[idx])
end

# ╔═╡ 101f7b4c-94dc-4a4a-9e14-550b01916354
md"""
## Generic solution
"""

# ╔═╡ 1032f410-b3ce-495d-848a-a5115be89220
function f(numbers::Vector{Int}, freq::Int)
	num_digits = length(numbers)
	if num_digits < freq
		return numbers
	end
	
	idx = freq:freq:num_digits
	return f(numbers[idx], freq)
end

# ╔═╡ 92d87b88-b075-4e45-a94f-36626a81e03e
f(numbers)

# ╔═╡ eb5d942e-1b87-489f-91d5-41d4d344d155
f(numbers, 3)

# ╔═╡ 7b49c8f4-e28d-4ff2-843b-4542a8b82109
md"""
## Discussions
"""

# ╔═╡ d77639a7-27b2-404c-92dc-9e925071a43a
md"""
### Number emulation
"""

# ╔═╡ 5f53d041-cebe-486d-b76a-fb80be0f17d1
function emulate_number_1()
	numbers = []
	for i in 1:10
		for i in 9:-1:0
			push!(numbers, i)
		end
	end
	return numbers
end

# ╔═╡ 938257f3-c6c0-49b1-a057-c8c35b7bb355
function emulate_number_2()
	repeat(9:-1:0, 20)
end

# ╔═╡ b5bae6ea-09f8-4b87-95f4-083071ad8c30
function emulate_number_3()
	mod.(199:-1:0, 10)
end

# ╔═╡ d46906f4-4f41-418f-9743-544f6672f70f
begin
	t1 = @elapsed emulate_number_1()
	t2 = @elapsed emulate_number_2()
	t3 = @elapsed emulate_number_3()
	(t1, t2, t3)
end

# ╔═╡ Cell order:
# ╟─295d0c40-d871-11eb-3aaa-2b04d2d668b3
# ╟─5c007783-19b1-472d-8d12-1f427ac363a9
# ╟─40d5c166-7726-47c4-bf35-01475c4bff29
# ╠═0b1d443c-b6f4-4701-8223-519f95888a29
# ╟─f7873d04-ca90-4fe5-bc07-9767b1593e38
# ╟─d68b05c4-ff14-4df3-b5fd-1661cc7777c3
# ╠═107fa4fe-1f8d-49fb-ba86-5b0812c9c983
# ╠═92d87b88-b075-4e45-a94f-36626a81e03e
# ╟─101f7b4c-94dc-4a4a-9e14-550b01916354
# ╠═1032f410-b3ce-495d-848a-a5115be89220
# ╠═eb5d942e-1b87-489f-91d5-41d4d344d155
# ╟─7b49c8f4-e28d-4ff2-843b-4542a8b82109
# ╟─d77639a7-27b2-404c-92dc-9e925071a43a
# ╟─5f53d041-cebe-486d-b76a-fb80be0f17d1
# ╟─938257f3-c6c0-49b1-a057-c8c35b7bb355
# ╟─b5bae6ea-09f8-4b87-95f4-083071ad8c30
# ╠═d46906f4-4f41-418f-9743-544f6672f70f
