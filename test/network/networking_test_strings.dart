class NetworkingTestStrings {
  static const NodeHello = "NodeHello\nCompressionCodecs=4 - GZIP(0), BZIP2(1), LZMA(2), LZMA_NEW(3)\nRevision=build01475\nTestnet=false\nVersion=Fred,0.7,1.0,1475\nBuild=1475\nConnectionIdentifier=6f467be43d838f8e02877e7f176a73bd\nNode=Fred\nExtBuild=29\nFCPVersion=2.0\nNodeLanguage=ENGLISH\nExtRevision=v29\nEndMessage";

  static const SSKKeypair = "SSKKeypair\nInsertURI=freenet:SSK@AKTTKG6YwjrHzWo67laRcoPqibyiTdyYufjVg54fBlWr,AwUSJG5ZS-FDZTqnt6skTzhxQe08T-fbKXj8aEHZsXM/\nRequestURI=freenet:SSK@BnHXXv3Fa43w~~iz1tNUd~cj4OpUuDjVouOWZ5XlpX0,AwUSJG5ZS-FDZTqnt6skTzhxQe08T-fbKXj8aEHZsXM,AQABAAE/\nIdentifier=My Identifier from GenerateSSK\nEndMessage";

  static const AllData = "AllData\nIdentifier=Request Number One\nDataLength=37261\nStartupTime=1189683889\nCompletionTime=1189683889\nMetadata.ContentType=text/plain;charset=utf-8\nData\nSGVsbG8gV29ybGQh";

  static const PutSuccessful = "PutSuccessful\nGlobal=true\nIdentifier=My Identifier\nStartupTime=1189683889\nCompletionTime=1189683889\nURI=CHK@NOSdw7FF88S0HBF2RDgQFGV-S8mruFnO5aHbjP0DVkE,oB8OplZBo9txoHNEKDifFMR34BgOPxSPqv~bNg7YsgM,AAEC--8\nEndMessage";
}