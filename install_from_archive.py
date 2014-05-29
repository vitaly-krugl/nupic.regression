import requests
import tarfile

REGION = "us-west-2"
BUCKET = "artifacts.numenta.org"
REPO = "numenta/nupic"
SHA_FILE = "nupic_sha.txt"


def fetchNupicTarballFor(sha):
  tarballName = "nupic-linux64-%s.tar.gz" % sha
  s3Url = "https://s3-%s.amazonaws.com/%s/%s/%s" % (REGION, BUCKET, REPO, tarballName)
  print "Fetching archive from %s..." % s3Url
  with open(tarballName, "wb") as handle:
    response = requests.get(s3Url, stream=True)
    if not response.ok:
      raise Exception("Cannot fetch tarball from %s" % s3Url)
    for block in response.iter_content(1024):
      if not block:
        break
      handle.write(block)



def untar(filePath):
  print "Unzipping %s..." % filePath
  tarBall = tarfile.open(filePath, 'r:gz')
  tarBall.extractall('.')


def getSha():
  with open(SHA_FILE, "r") as shaFile:
    return shaFile.read().strip()


if __name__ == "__main__":
  sha = getSha()
  fetchNupicTarballFor(sha)
  untar("nupic-linux64-%s.tar.gz" % sha)
