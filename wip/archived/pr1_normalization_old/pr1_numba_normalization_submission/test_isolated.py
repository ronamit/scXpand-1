#!/usr/bin/env python3
"""Isolated test to understand the column sum issue."""

import sys

import numpy as np
import scipy.sparse as sp


# Add the scanpy source to the path
sys.path.insert(0, "/Users/rona/my_repos/scanpy/src")

from scanpy.preprocessing._normalization_optimized import _csr_sum_and_squared_sum_optimized


def test_column_sums_isolated():
    """Test column sums in isolation."""
    # Create a simple test matrix
    np.random.seed(42)
    X_dense = np.random.poisson(3, (100, 50))
    X_sparse = sp.csr_matrix(X_dense, dtype=np.float64)

    print(f"Test matrix: {X_sparse.shape}, nnz: {X_sparse.nnz}")

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

    print(f"col_sums shape: {col_sums.shape}, dtype: {col_sums.dtype}")
    print(f"col_sums_ref shape: {col_sums_ref.shape}, dtype: {col_sums_ref.dtype}")
    print(f"col_sq_sums shape: {col_sq_sums.shape}, dtype: {col_sq_sums.dtype}")
    print(f"col_sq_sums_ref shape: {col_sq_sums_ref.shape}, dtype: {col_sq_sums_ref.dtype}")

    print(f"First 5 col_sums: {col_sums[:5]}")
    print(f"First 5 col_sums_ref: {col_sums_ref[:5]}")
    print(f"First 5 differences: {(col_sums - col_sums_ref)[:5]}")

    if max_diff_sums < 1e-10 and max_diff_sq_sums < 1e-10:
        print("✓ Column sum computation: PASSED")
        return True
    else:
        print("✗ Column sum computation: FAILED")
        return False


if __name__ == "__main__":
    test_column_sums_isolated()
