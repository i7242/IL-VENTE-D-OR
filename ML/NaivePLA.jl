### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 65eb8786-487a-11eb-2043-5d6a237f9a7e
using Plots

# ╔═╡ 13021374-4879-11eb-0eaa-ff0e2755ceff
md""" # Naive PLA"""

# ╔═╡ 4c1705b6-4879-11eb-17a0-15f9a97f36bd
md""" ## Generate some data"""

# ╔═╡ 0d9aab48-487a-11eb-0aee-f1a14404ea00
md""" assumes we have 2D points uniformaly distributed in a square"""

# ╔═╡ 3ccc5d30-487a-11eb-031b-a31ae42a4552
begin
	points = rand(2,10)
end

# ╔═╡ 20806158-487f-11eb-13e0-0151542c2864
md"""assume we have a separation line passing throw the center point, [0.5, 0.5], random generate the line and labeling the points

$a\cdot x + b\cdot y +c = 0$

since it passing [0.5,0.5], we can also pick two vectors, $v$ is the direction of line, and $w$ is the normal direction of line, then we have $v^Tw = 0$"""

# ╔═╡ 88da45a4-487f-11eb-088c-997077526c6c
begin
	a = rand(1:9)
	b = rand(1:9)*sign(rand(-1:2:1))
	c = - 0.5a - 0.5b
	v = [0.5; -0.5-(a + c)/b]
	w = [1; -0.5/v[2]]
end

# ╔═╡ f88baf64-4882-11eb-090c-9b82584c83b6
labels = sign.((points .- [0.5;0.5])'w)

# ╔═╡ d629b906-487e-11eb-0268-c94b309a6717
begin
	plt1 = scatter(points[1,labels .> 0], points[2, labels .> 0])
	plt1 = scatter!(points[1,labels .< 0], points[2, labels .< 0])
end

# ╔═╡ 4a412892-4884-11eb-3b3f-1d2de706d138
md""" ## Algorithm"""

# ╔═╡ 90e62a08-4885-11eb-0925-b108ecfe4f1d
md"""now assume we still have the center point, and find the new separation line normal"""

# ╔═╡ cd676dfc-4885-11eb-1bdf-8be5e1233997
normal = rand(2)

# ╔═╡ db1c9436-4885-11eb-252e-25b7cc4dc544
for i in 1: 500
	for idx in 1:size(points)[2]
		u = points[:, idx] - [0.5;0.5]
		if u'*normal*labels[idx] < 0
			normal += u
		end
	end
end

# ╔═╡ 702f881c-4886-11eb-32c6-19badba91047
normal

# ╔═╡ 8f2eb6b6-4886-11eb-1a3f-1776041dcc17
w

# ╔═╡ eb153d64-4887-11eb-28dc-c7edf2629b44
new_labels = sign.((points .- [0.5;0.5])'normal)

# ╔═╡ f2a97e3c-4887-11eb-24b3-2977e7d2424a
begin
	plt2 = scatter(points[1,new_labels .> 0], points[2, new_labels .> 0])
	plt2 = scatter!(points[1,new_labels .< 0], points[2, new_labels .< 0])
end

# ╔═╡ Cell order:
# ╟─13021374-4879-11eb-0eaa-ff0e2755ceff
# ╠═65eb8786-487a-11eb-2043-5d6a237f9a7e
# ╟─4c1705b6-4879-11eb-17a0-15f9a97f36bd
# ╟─0d9aab48-487a-11eb-0aee-f1a14404ea00
# ╠═3ccc5d30-487a-11eb-031b-a31ae42a4552
# ╟─20806158-487f-11eb-13e0-0151542c2864
# ╠═88da45a4-487f-11eb-088c-997077526c6c
# ╠═f88baf64-4882-11eb-090c-9b82584c83b6
# ╠═d629b906-487e-11eb-0268-c94b309a6717
# ╟─4a412892-4884-11eb-3b3f-1d2de706d138
# ╠═90e62a08-4885-11eb-0925-b108ecfe4f1d
# ╠═cd676dfc-4885-11eb-1bdf-8be5e1233997
# ╠═db1c9436-4885-11eb-252e-25b7cc4dc544
# ╠═702f881c-4886-11eb-32c6-19badba91047
# ╠═8f2eb6b6-4886-11eb-1a3f-1776041dcc17
# ╠═eb153d64-4887-11eb-28dc-c7edf2629b44
# ╠═f2a97e3c-4887-11eb-24b3-2977e7d2424a
