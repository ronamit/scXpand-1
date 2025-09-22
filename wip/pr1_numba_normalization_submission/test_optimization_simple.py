#!/usr/bin/env python3
"""Simple test to verify our optimization functions work."""

import sys

import numpy as np
import scipy.sparse as sp


# Add the scanpy source to the path
sys.path.insert(0, "/Users/rona/my_repos/scanpy/src")

try:
    from scanpy.preprocessing._normalization_optimized import (
        _compute_row_sums_optimized,
        _csr_row_scaling_optimized,
        _csr_sum_and_squared_sum_optimized,
        apply_row_normalization_optimized,
    )

    print("✓ Successfully imported optimized functions")
except ImportError as e:
    print(f"✗ Failed to import optimized functions: {e}")
    sys.exit(1)


def test_basic_functionality():
    """Test basic functionality of optimized functions."""
    print("\n" + "=" * 50)
    print("Testing Basic Functionality")
    print("=" * 50)

    # Create a simple test matrix
    np.random.seed(42)
    X_dense = np.random.poisson(3, (100, 50))
    X_sparse = sp.csr_matrix(X_dense, dtype=np.float64)

    print(f"Test matrix: {X_sparse.shape}, nnz: {X_sparse.nnz}")

    # Test 1: Row sums
    print("\nTest 1: Row sum computation")
    row_sums_opt = _compute_row_sums_optimized(X_sparse.data, X_sparse.indptr, X_sparse.shape[0])
    row_sums_ref = np.array(X_sparse.sum(axis=1)).flatten()

    max_diff = np.max(np.abs(row_sums_opt - row_sums_ref))
    print(f"Max difference from reference: {max_diff:.2e}")

    if max_diff < 1e-10:
        print("✓ Row sum computation: PASSED")
    else:
        print("✗ Row sum computation: FAILED")
        return False

    # Test 2: Column sums and squared sums
    print("\nTest 2: Column sum and squared sum computation")
    col_sums, col_sq_sums = _csr_sum_and_squared_sum_optimized(
        X_sparse.data, X_sparse.indices, X_sparse.indptr, X_sparse.shape[0], X_sparse.shape[1]
    )

    col_sums_ref = np.array(X_sparse.sum(axis=0)).flatten()
    col_sq_sums_ref = np.array((X_sparse.multiply(X_sparse)).sum(axis=0)).flatten()

    max_diff_sums = np.max(np.abs(col_sums - col_sums_ref))
    max_diff_sq_sums = np.max(np.abs(col_sq_sums - col_sq_sums_ref))

    print(f"Max difference in sums: {max_diff_sums:.2e}")
    print(f"Max difference in squared sums: {max_diff_sq_sums:.2e}")

    if max_diff_sums < 1e-10 and max_diff_sq_sums < 1e-10:
        print("✓ Column sum computation: PASSED")
    else:
        print("✗ Column sum computation: FAILED")
        return False

    # Test 3: Row scaling
    print("\nTest 3: Row scaling")
    X_test = X_sparse.copy()
    scaling_factors = np.random.uniform(0.5, 2.0, X_sparse.shape[0])

    _csr_row_scaling_optimized(X_test.data, X_test.indptr, scaling_factors, X_test.shape[0])

    # Verify scaling worked correctly
    new_row_sums = np.array(X_test.sum(axis=1)).flatten()
    expected_row_sums = row_sums_ref * scaling_factors

    max_diff_scaling = np.max(np.abs(new_row_sums - expected_row_sums))
    print(f"Max difference after scaling: {max_diff_scaling:.2e}")

    if max_diff_scaling < 1e-10:
        print("✓ Row scaling: PASSED")
    else:
        print("✗ Row scaling: FAILED")
        return False

    # Test 4: Complete normalization pipeline
    print("\nTest 4: Complete normalization pipeline")
    X_test = X_sparse.copy()
    target_sum = 10000.0

    scaling_factors, counts = apply_row_normalization_optimized(X_test, target_sum=target_sum)

    # Check that row sums are approximately target_sum
    final_row_sums = np.array(X_test.sum(axis=1)).flatten()
    max_deviation = np.max(np.abs(final_row_sums - target_sum))
    mean_deviation = np.mean(np.abs(final_row_sums - target_sum))

    print(f"Target sum: {target_sum}")
    print(f"Max deviation: {max_deviation:.2e}")
    print(f"Mean deviation: {mean_deviation:.2e}")

    if max_deviation < 1e-6:
        print("✓ Complete normalization pipeline: PASSED")
    else:
        print("✗ Complete normalization pipeline: FAILED")
        return False

    return True


def test_performance():
    """Basic performance test."""
    print("\n" + "=" * 50)
    print("Basic Performance Test")
    print("=" * 50)

    # Create a larger test matrix
    np.random.seed(42)
    n_obs, n_vars = 10000, 5000
    density = 0.05

    print(f"Creating test matrix: {n_obs}x{n_vars} with density {density}")
    X_dense = np.random.poisson(2, (n_obs, n_vars))
    mask = np.random.random((n_obs, n_vars)) < density
    X_dense = X_dense * mask
    X_sparse = sp.csr_matrix(X_dense, dtype=np.float64)

    print(f"Matrix created: shape={X_sparse.shape}, nnz={X_sparse.nnz}")

    # Time the normalization
    import time

    start_time = time.perf_counter()
    scaling_factors, counts = apply_row_normalization_optimized(X_sparse)
    end_time = time.perf_counter()

    elapsed_time = end_time - start_time
    throughput = n_obs / elapsed_time

    print(f"Normalization time: {elapsed_time:.4f} seconds")
    print(f"Throughput: {throughput:.0f} cells/second")

    # Verify correctness
    row_sums = np.array(X_sparse.sum(axis=1)).flatten()
    target_sum = 10000.0
    max_deviation = np.max(np.abs(row_sums - target_sum))

    print(f"Max deviation from target: {max_deviation:.2e}")

    if max_deviation < 1e-6:
        print("✓ Performance test: PASSED")
        return True
    else:
        print("✗ Performance test: FAILED")
        return False


def main():
    """Run all tests."""
    print("Scanpy Normalization Optimization - Simple Test Suite")
    print("=" * 60)

    all_passed = True

    # Test basic functionality
    if not test_basic_functionality():
        all_passed = False

    # Test performance
    if not test_performance():
        all_passed = False

    # Summary
    print("\n" + "=" * 60)
    if all_passed:
        print("🎉 ALL TESTS PASSED!")
        print("The optimization functions are working correctly.")
    else:
        print("❌ SOME TESTS FAILED!")
        print("Please check the implementation.")
        sys.exit(1)


if __name__ == "__main__":
    main()
