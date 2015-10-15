import unittest2 as unittest
import json, os


BENCHMARK_PATH = "tests/anomaly/NAB/benchmark_results.json"
RESULTS_PATH = os.environ['NAB'] + "/results/final_results.json"
EPS = 10e-2



class NABAnomalyTest(unittest.TestCase):
  """Regression tests for NAB on nupic."""



  def testNABScoresBenchmark(self):
    """Test that NAB on nupic produces expected scores."""
        
    with open(BENCHMARK_PATH) as benchmarkFile:
      benchmarkData = json.load(benchmarkFile)

    with open(RESULTS_PATH) as resultsFile:
      resultsData = json.load(resultsFile)

    for benchmarkName in benchmarkData["numenta"]:
      benchmarkValue = benchmarkData["numenta"][benchmarkName]
      resultValue = resultsData["numenta"][benchmarkName]
      self.assertAlmostEqual(benchmarkValue, resultValue, delta=EPS)


if __name__ == "__main__":
  unittest.main()
