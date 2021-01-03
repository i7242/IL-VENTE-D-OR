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
md""" assumes we have 2D points uniformaly distributed in a square
we also augment it with value "1" to use bias coefficient"""

# ╔═╡ 3ccc5d30-487a-11eb-031b-a31ae42a4552
begin
	num_points = 100
	points = [ones(1, num_points); rand(2, num_points)]
end

# ╔═╡ 20806158-487f-11eb-13e0-0151542c2864
md"""assume we have a separation line passing throw the center point, [0.5, 0.5], then randomly generate the line

$a\cdot x + b\cdot y +c = 0$

we will have weight vector $w = [c, a, b]$ represent the line, and corresponding augmented variables are $x^* = [1, x, y]$

the label of point is defined as $sign(w'x^*)$"""

# ╔═╡ 88da45a4-487f-11eb-088c-997077526c6c
begin
	# configuration of the coefficients were based on it will pass [0.5, 0.5] point
	a = rand(1:9)
	b = rand(1:9)*sign(rand(-1:2:1))
	c = - 0.5a - 0.5b
	w = [c, a, b]
end

# ╔═╡ f88baf64-4882-11eb-090c-9b82584c83b6
labels = sign.(points'w)

# ╔═╡ d629b906-487e-11eb-0268-c94b309a6717
begin
	plt1 = scatter(points[2,labels .> 0], points[3, labels .> 0])
	plt1 = scatter!(points[2,labels .< 0], points[3, labels .< 0])
end

# ╔═╡ 4a412892-4884-11eb-3b3f-1d2de706d138
md""" ## Algorithm"""

# ╔═╡ 0f2fbb72-4dea-11eb-1160-3105cf1c79e0
md"""here is a simple PLA, which will stop in a given iterations"""

# ╔═╡ 280c900c-4dea-11eb-2700-df24f3504fc7
function pla_train(points, labels, iter = 500)
	w = rand(3)
	for i in 1:iter
		for idx in 1:size(points)[2]
			u = points[:, idx]'w
			if u*labels[idx] < 0
				w += points[:, idx]*labels[idx]
			end
		end
	end
	return w
end

# ╔═╡ 4d37eac8-4de7-11eb-2904-5dd9cb72f633
function pla_predict(points, w)
	labels = sign.(points'w)
end

# ╔═╡ 11540972-4deb-11eb-007f-2fbce246e9db
md"""before training & testing, lets separate the generated points into two sets"""

# ╔═╡ 24aa62da-4deb-11eb-1565-91e5ebcac540
begin
	points_train = points[:, 1:Int(size(points)[2]*4/5)]
	points_test = points[:, Int(size(points)[2]*4/5)+1:end]
	labels_train = labels[1:Int(size(points)[2]*4/5)]
	labels_test = labels[Int(size(points)[2]*4/5)+1:end]
end

# ╔═╡ 992b8bda-4dea-11eb-3d90-c9b5c49cc8be
begin
	new_w = pla_train(points_train, labels_train)
	result_train = pla_predict(points_train, new_w)
end

# ╔═╡ 1d441764-4ded-11eb-3f83-3bbb6d619b7a
md"""after training, the results on training set is:"""

# ╔═╡ f2a97e3c-4887-11eb-24b3-2977e7d2424a
begin
	plt2 = scatter(points_train[2,result_train .> 0], points_train[3,result_train .> 0])
	plt2 = scatter!(points_train[2,result_train .< 0], points_train[3, result_train .< 0])
end

# ╔═╡ 2d20cfc4-4ded-11eb-1582-a99c10618098
md"""test on the testing set:"""

# ╔═╡ 43243d7a-4dec-11eb-25cf-c916ff4d5c82
begin
	result_test = pla_predict(points_test, new_w)
	plt3 = scatter(points_test[2,result_test .> 0], points_test[3, result_test .> 0])
	plt3 = scatter!(points_test[2,result_test .< 0], points_test[3, result_test .< 0])
end

# ╔═╡ bf1d2012-4ded-11eb-306f-e165b62a28bb
md"""number of miss classification on test set is:"""

# ╔═╡ 94070b36-4ded-11eb-1315-832bc5f95c69
sum(result_test .!= labels_test)

# ╔═╡ 1709787a-4dee-11eb-3088-6b292638b8af
md"""## Conclusion"""

# ╔═╡ 3a151822-4dee-11eb-2a2b-4582cb64db00
md"""PLA is the very fundmental binary classification algorithm. Here we didn't introduce noise and handle it. Pocket PLA is simaler to this naive PLA.

Termination of training is simply runing certain loops, since the data is simple and separatable.

The augmented variable vector $[x_0 = 1, x_1, x_2, ... x_n]$ is also used in matrix form of neural networks.

Ref: 林轩田 机器学习基石 https://www.coursera.org/learn/ntumlone-mathematicalfoundations
"""

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
# ╟─0f2fbb72-4dea-11eb-1160-3105cf1c79e0
# ╠═280c900c-4dea-11eb-2700-df24f3504fc7
# ╠═4d37eac8-4de7-11eb-2904-5dd9cb72f633
# ╟─11540972-4deb-11eb-007f-2fbce246e9db
# ╠═24aa62da-4deb-11eb-1565-91e5ebcac540
# ╠═992b8bda-4dea-11eb-3d90-c9b5c49cc8be
# ╟─1d441764-4ded-11eb-3f83-3bbb6d619b7a
# ╠═f2a97e3c-4887-11eb-24b3-2977e7d2424a
# ╟─2d20cfc4-4ded-11eb-1582-a99c10618098
# ╠═43243d7a-4dec-11eb-25cf-c916ff4d5c82
# ╟─bf1d2012-4ded-11eb-306f-e165b62a28bb
# ╠═94070b36-4ded-11eb-1315-832bc5f95c69
# ╟─1709787a-4dee-11eb-3088-6b292638b8af
# ╟─3a151822-4dee-11eb-2a2b-4582cb64db00
