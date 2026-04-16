import numpy as np
import matplotlib.pyplot as plt

def derivative_8(f, x, h):
    return (f(x+h)-f(x-h))/(2*h)

def derivative_12(f, x, h):
    return (-f(x+2*h) + 4*f(x+h) - 3*f(x)) / (2*h)

def derivative_13(f, x, h):
    return (3*f(x) - 4*f(x-h) + f(x-2*h)) / (2*h)



def plot_error(h_values, error,  xlabel='x', ylabel='Error', title='Error between Finite Difference and Analytical Solution'):
    ''' loglog plot of error '''

    # Reference error is h^2 for all three methods, so we can plot a reference line for h^2 to compare the slopes.
    h_ref = np.array(h_values)
    error_array = np.array(error)

    # Scale the reference line to start at the same point as the real error
    error_ref = h_ref**2
    scale_factor = error_array[0] / error_ref[0]
    error_ref = error_ref * scale_factor
    plt.loglog(h_ref, error_ref, label='Reference: h^2', linestyle='--')

    plt.loglog(h_ref, error, label='Error')
    plt.gca().invert_xaxis()
    plt.xlabel('h')
    plt.ylabel(ylabel)
    plt.title(title)
    plt.legend()
    plt.show()


def main():
    def f(x): return np.sin(np.exp(x))

    def f_prime_analytical(x): return np.cos(np.exp(x)) * np.exp(x)

    x = 0.75
    K = [1,2,3,4,5,6,7,8]
    def h(k): return 2**(-k)

    error = {'error_8': [], 'error_12': [], 'error_13': []}

    for k in K:
        h_k = h(k)
        d_8 = derivative_8(f, x, h_k)
        d_12 = derivative_12(f, x, h_k)
        d_13 = derivative_13(f, x, h_k)
        d_analytical = f_prime_analytical(x)

        error_8 = abs(d_8 - d_analytical)
        error_12 = abs(d_12 - d_analytical)
        error_13 = abs(d_13 - d_analytical)

        error['error_8'].append(error_8)
        error['error_12'].append(error_12)
        error['error_13'].append(error_13)

        print(f"h = {h_k:.5e}, 8-point error: {error_8:.5e}, 12-point error: {error_12:.5e}, 13-point error: {error_13:.5e}")

    # Plot the errors
    plot_error([h(k) for k in K], error['error_8'], xlabel='h', ylabel='Error', title='8-point Finite Difference Error')
    plot_error([h(k) for k in K], error['error_12'], xlabel='h', ylabel='Error', title='12-point Finite Difference Error')
    plot_error([h(k) for k in K], error['error_13'], xlabel='h', ylabel='Error', title='13-point Finite Difference Error')

    # calculate the order of convergence using polyfit on the log-log data
    for method in error:
        log_h = np.log([h(k) for k in K])
        log_error = np.log(error[method])
        slope, intercept = np.polyfit(log_h, log_error, 1)
        print(f"{method} order of convergence: {abs(slope):.2f}")




if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Program interrupted by user.")