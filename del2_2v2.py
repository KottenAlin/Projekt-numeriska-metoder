import numpy as np
import matplotlib.pyplot as plt

try:
	from scipy.linalg import solve_banded
except ImportError:
	solve_banded = None


T_INF = 293.15
SIGMA = 5.67e-8
STRETCH_POWER = 2.5
N = 1000
L_REF = 100.0

SETUP_8_4A = {
	"D": 5.0e-3,
	"T_s": 373.15,
	"materials": {
		"SS AISI 316": {"K": 14, "h_c": 100, "epsilon": 0.17},
		"Aluminium": {"K": 180, "h_c": 100, "epsilon": 0.85},
		"Copper": {"K": 398, "h_c": 100, "epsilon": 0.03},
	},
}


def stretched_grid(L, n=N, p=STRETCH_POWER):
	return L * np.linspace(0.0, 1.0, n + 1) ** p


def solve_temperature(a1, a2, T_s, L, n=N, p=STRETCH_POWER):
	x = stretched_grid(L, n, p)
	T = np.linspace(T_s, T_INF, n + 1)
	T[0], T[-1] = T_s, T_INF

	for _ in range(1000):
		F = np.zeros(n - 1)
		ab = np.zeros((3, n - 1))
		for i in range(1, n):
			hm, hp = x[i] - x[i - 1], x[i + 1] - x[i]
			row = i - 1
			lower = 2.0 / (hm * (hm + hp))
			diag = -2.0 / (hm + hp) * (1.0 / hm + 1.0 / hp)
			upper = 2.0 / (hp * (hm + hp))
			Txx = lower * T[i - 1] + diag * T[i] + upper * T[i + 1]
			F[row] = Txx - (a1 * (T[i] - T_INF) + a2 * (T[i] ** 4 - T_INF ** 4))
			ab[1, row] = diag - (a1 + 4.0 * a2 * T[i] ** 3)
			if row > 0:
				ab[2, row - 1] = lower
			if row < n - 2:
				ab[0, row + 1] = upper

		if solve_banded is not None:
			dT = solve_banded((1, 1), ab, -F)
		else:
			J = np.zeros((n - 1, n - 1))
			for i in range(n - 1):
				J[i, i] = ab[1, i]
				if i > 0:
					J[i, i - 1] = ab[2, i - 1]
				if i < n - 2:
					J[i, i + 1] = ab[0, i + 1]
			dT = np.linalg.solve(J, -F)
		T[1:-1] += dT
		if np.linalg.norm(dT, ord=np.inf) < 1e-6:
			break
	return x, T


def reference_error(a1, a2, T_s, L, L_ref=L_REF):
	x, T = solve_temperature(a1, a2, T_s, L)
	x_ref, T_ref = solve_temperature(a1, a2, T_s, L_ref)
	T_ref_on_x = np.interp(x, x_ref, T_ref)
	error = T - T_ref_on_x
	return x, T, T_ref_on_x, error, np.sqrt(np.mean(error**2))


def find_infinite_length(a1, a2, T_s, rel_tol=1e-3, L0=0.01, L_max=100.0, material=None):
	results = []
	L_vals = []
	estimate = None
	L = L0
	threshold = rel_tol * (T_s - T_INF)

	while L < L_max:
		_, _, _, error, rmse = reference_error(a1, a2, T_s, L)
		print(f"L={L:.3f}, RMSE={rmse:.6e}, rel={rmse / (T_s - T_INF):.6e}")
		results.append(rmse)
		L_vals.append(L)
		if estimate is None and rmse < threshold:
			estimate = L
		L *= 1.1

	plt.plot(L_vals, results)
	plt.xscale("log")
	plt.yscale("log")
	plt.xlabel("L")
	plt.ylabel("RMSE vs $T_{ref}$")
	plt.title(f"8.4.b: Error against reference solution for {material}")
	plt.grid()
	plt.show()

	return estimate


def main():
	for name, props in SETUP_8_4A["materials"].items():
		a1 = 4 * props["h_c"] / (SETUP_8_4A["D"] * props["K"])
		a2 = 4 * props["epsilon"] * SIGMA / (SETUP_8_4A["D"] * props["K"])
		L_inf = find_infinite_length(a1, a2, SETUP_8_4A["T_s"], material=name)
		if L_inf is None:
			print(f"{name}: no estimate within search range")
		else:
			print(f"{name}: estimated infinite length = {L_inf:.3f} m")


if __name__ == "__main__":
	main()
