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

The entry point of the program is the routine `INTER7_CANDIDATE_PAIRS` located in the file `inter7_candidate_pairs.F`.  
This routine contains the collision detection algorithm for `/INTER/TYPE7` (in a somewhat simplified form).


