# Trabalho 4 Sistemas Digitais The Last of All

## 1. Calculo de X e Y
- Matrícula: **23180609-2**
- Soma dos dígitos: 2 + 3 + 1 + 8 + 0 + 6 + 0 + 9 = **29**
- Dígito verificador: **2** (par ⇒ usamos '-')
- **X** (expoente) = 8 - (31 mod 4) = 8 - 1 = **7**
- **Y** (mantissa) = 31 - 7 = **24**

## 2. Arquivos
- `fpu_mat.sv` : Modulo da FPU
- `fpu_mat_tb.sv` : Testbench com os casos de teste
- `sim.do` : Script de Sim (ModelSim)
- `README.md` : Este arquivo

## 3. Como simular
1. Abra o ModelSim
2. No console:
   do sim.do
3. Verifique a saida dos testes no console.

## 4. Resultados
Os testes cobrem:
- Soma com zero
- Subtração resultando em zero
- Casos de overflow e underflow
- Varios valores aleatórios
