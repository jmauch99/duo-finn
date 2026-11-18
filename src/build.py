"""Gera ../index.html a partir de template.html + icons.json + cc.json.
Uso (na raiz do repositório):  python3 src/build.py
O backup pessoal embutido nos testes locais NÃO vai para o site publicado: os dados ficam só no banco."""
import json, re, pathlib
D = pathlib.Path(__file__).parent
t = (D / 'template.html').read_text(encoding='utf-8')
for k, v in json.loads((D / 'icons.json').read_text()).items():
    t = t.replace('__ICON_%s__' % k, v)
for k, v in json.loads((D / 'cc.json').read_text()).items():
    t = t.replace('__CC_%s__' % k, v['src']).replace('__CCR_%s__' % k, str(v['ratio']))
assert '__ICON_' not in t and '__CC_' not in t and '__CCR_' not in t
VAZIO = '{"v":2,"tema":"light","mes":"2026-11","nomes":{"eu":"James","esposa":"Bruna"},"ui":{"view":"geral","dia":null,"card":0,"fluxo":"data"},"reserva":{"saldoInicial":0},"categorias":[],"cartoes":[],"faturas":{},"meses":{},"compras":[],"investIni":0}'
t, n = re.subn(r'const SEED_DATA = \{.*\};', lambda m: 'const SEED_DATA = ' + VAZIO + ';', t, count=1)
assert n == 1
(D.parent / 'index.html').write_text(t, encoding='utf-8')
print('index.html', len(t) // 1024, 'KB')
