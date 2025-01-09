This is a standalone part of [OpenRadioss](https://github.com/OpenRadioss/OpenRadioss) that performs the collision detection on a given dataset
# Usage

## Step 1: Build the Data File

To build the data file, run the following commands:

```bash
cat t10m.dat.tgz.part* > t10m.dat.tgz
tar -xzvf t10m.dat.tgz
```

## Step 2: Build and Run

Choose the appropriate compiler and execute the following commands:

- For **NVFortran**:
  ```bash
  make COMP=nvfortran run
  ```
- For **GFortran** (default):
  ```bash
  make COMP=gfortran run
  # or simply:
  make run
  ```
- For **Intel**:
  ```bash
  make COMP=intel run
  ```

## Step 3: Check the Results

After running the program, the expected output should be:

```
Success: All candidates_ref are found in candidates.
```

# Code

The entry point of the program is the routine `INTER7_CANDIDATE_PAIRS` located in the file [`inter7_candidate_pairs.F`](https://github.com/laurent-altr/OpenRadioss_contact_sandbox/blob/main/inter7_candidate_pairs.F).
This routine contains the collision detection algorithm for `/INTER/TYPE7` (in a somewhat simplified form).

## Key concepts

This routine handles the broad phase of the collision detection algorithm. Its purpose is to identify pairs of main quadrangles and secondary nodes that are within a specified distance of each other.

The 3D coordinates of all nodes are stored in the array `X`.
A subset of these nodes, referred to as secondary nodes, is listed in the array `NSV`.
The main surface is divided into `NRTM` quadrangles, with the IDs of their nodes stored in the `IRECT` array.
It is important to note that secondary nodes may also belong to the main surface.

