import numpy as np
import matplotlib.pyplot as plt

def derivative_8(f, x, h):
    return (f(x+h)-f(x-h))/(2*h)

def derivative_12(f, x, h):
    return (-f(x+2*h) + 4*f(x+h) - 3*f(x)) / (2*h)

def derivative_13(f, x, h):
    return (3*f(x) - 4*f(x-h) + f(x-2*h)) / (2*h)



def plot_error(h_values, errors, title='Trunkeringsfel för differensapproximationer'):
    ''' loglog plot of error '''

    # Reference error is h^2 for all three methods, so we can plot a reference line for h^2 to compare the slopes.
    h_ref = np.array(h_values)

    # Scale the reference line to start at the same point as the real error
    error_ref = h_ref**2
    scale_factor = errors['error_8'][0] / error_ref[0]
    error_ref = error_ref * scale_factor
    plt.loglog(h_ref, error_ref, label='Referens: O(h^2)', linestyle='--', color='gray')

    plt.loglog(h_ref, errors['error_8'], label='Ekvation 8 (Central)', marker='o')
    plt.loglog(h_ref, errors['error_12'], label='Ekvation 12 (Framåt)', marker='s')
    plt.loglog(h_ref, errors['error_13'], label='Ekvation 13 (Bakåt)', marker='^')

    plt.gca().invert_xaxis()
    plt.xlabel('h')
    plt.ylabel('Fel (Error)')
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

    print(f"Analytical derivative at x={x}: {f_prime_analytical(x):.5e}")

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
        print(f"h = {h_k:.5e}, eq8: {d_8:.5e}, eq12: {d_12:.5e}, eq13: {d_13:.5e}")
        print(f"eq8 error : {error_8:.5e}, eq12 error: {error_12:.5e}, eq13 error: {error_13:.5e}")

    #print the results in a table format


    # Plot the errors
    plot_error([h(k) for k in K], error)

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