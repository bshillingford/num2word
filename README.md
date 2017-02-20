## num2word

Line-for-line Lua port of <http://stackoverflow.com/questions/25150316/convert-numbers-to-english-strings>

Python version fixed a "zero thousand" bug. Reasonably high quality for numbers smaller than a billion, but a few odd spellings left uncorrected e.g. 18.

### Test of equivalent implementation
```bash
luajit test_num2word.lua > lua.txt
python test_num2word.py > py.txt
diff lua.txt py.txt || echo "they are different"
```

