
import json
import os
import unittest


BENCHMARK_PATH = "tests/anomaly/nab/benchmark_results.json"
RESULTS_PATH = os.environ["NAB"] + "/results/final_results.json"
EPS = 10e-2



class NABAnomalyTest(unittest.TestCase):
  """ Regression tests for NAB on nupic.
  Running the NAB detections here times out the regressions tests, so instead we
  run the tests from from Travis build script, and simply check the results
  here.
  """


  def testNABScoresBenchmark(self):
    """Test that NAB on nupic produces expected scores."""

    with open(BENCHMARK_PATH) as benchmarkFile:
      benchmarkData = json.load(benchmarkFile)

    with open(RESULTS_PATH) as resultsFile:
      resultsData = json.load(resultsFile)

    for benchmarkName in benchmarkData["numenta"]:
      benchmarkValue = benchmarkData["numenta"][benchmarkName]
      resultValue = resultsData["numenta"][benchmarkName]
      self.assertAlmostEqual(benchmarkValue, resultValue, delta=EPS, msg=
          "Numenta detector scores don't check out for the {} profile".
          format(benchmarkName)
      )

    for benchmarkName in benchmarkData["numentaTM"]:
      benchmarkValue = benchmarkData["numentaTM"][benchmarkName]
      resultValue = resultsData["numentaTM"][benchmarkName]
      self.assertAlmostEqual(benchmarkValue, resultValue, delta=EPS, msg=
          "Numenta TM detector scores don't check out for the {} profile".
          format(benchmarkName)
      )



if __name__ == "__main__":
  unittest.main()
