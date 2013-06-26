from distutils.core import setup
setup(name='btcp',
  version='0.1.2',
  description='Pyhton BitTorrent copy. Can be used to copy files using BitTorrent framework',
  author='Sergey Sergeev',
  author_email='zhirafovod@gmail.com',
  #url='',
  packages=['btcp','PythonBittorrent'],
  data_files=[ # http://docs.python.org/2/distutils/setupscript.html#installing-package-data
    ('/etc/init.d', ['files/init.d/python-btcp-daemon']),
    ('/usr/bin', ['files/bin/btcp-copy.py']),
    ('/etc/btcp', ['btcp/btcp.tac']),
    ],
  )
