# Jamef API

Olá. Essa gem é um Ruby wrapper da API SOAP da *Jamef.com.br*. Use-a em qualquer projeto Ruby/Rails.

Você poderá facilmente

* **Consultar** frete e prazo de entrega
* ~~Rastrear encomendas despachadas~~ (#TO DO)

## 1. Consulta de Frete e Prazo (Rating)

Após a instalação da gem, realizar uma consulta de frete é bastante simples. São apenas 4 passos, veja uma resumo do processo:

1. Defina o **remetente** com `Jamef::Sender`
2. Defina o **destinatário** com `Jamef::Receiver`
3. Defina **a mercadoria que vai ser enviada** com `Jamef::Package`
4. Realize a **consulta** com `Jamef.rate` ou `Jamef.complete_rate`



### 1.1 - Remetente

Inicialize um objeto `Jamef::Sender` com as informações da sua empresa.

```ruby
my_company = Jamef::Sender.new({
  document: 'xxx',          # cnpj/cpf
  city: 'Jundiaí',          # sua cidade
  state: 'SP',              # seu estado
  jamef_branch: :campinas   # sua filial da jamef
})
```                           

**Importante:**

* `jamef_branch` é sempre o nome da cidade da filial da Jamef associada à sua conta. Veja a tabela no final do documento.

### 1.2 - Destinatário

Crie um destinatário com o `Jamef::Receiver`.

```ruby
receiver = Jamef::Receiver.new({
  zip: 'CEP AQUI',         # obrigatório: CEP
  document: 'CNPJ AQUI',   # opcional: cpf/cnpj do destinatário
  contrib: true            # opcional: Dest. é contribuinte?
}) 
```

### 1.3 - Mercadoria

Faça um pacote informando o volume final cubado (**m³**) e também seu peso (**kg**) com o `Jamef::Package`.

```ruby
package = Jamef::Package.new({
  weight: 5,            # kg - peso da encomenda
  package_price: 1000,  # R$ - valor da encomenda
  volume: 2,            # m³ - vol. total cubado
  type: :nf             # opcional (leia abaixo)
}) 
```

Este último parâmetro `type` está relacionado com o tipo de produto que será transportado. 

Você pode omitir `type: :nf` que é o valor padrão. O tipo `:nf` diz à Jamef para inferir o tipo de produto a partir da nota fiscal. Veja a tabela no final do documento para preencher o campo `type` adequadamente.

### 1.4 - Consulta

Há dois métodos que você pode usar para fazer a consulta: `Jamef.complete_rate` e `Jamef.rate`. Escolha a maneira mais adequada.

#### 1.4.1 Consulta com retorno simplificado

Você pode realizar uma consulta simples com o `Jamef::rate`

Em `shipping_in`, informe a data/horário (datetime) de coleta da encomenda.

```ruby
Jamef.rate({
  sender: my_company, 
  receiver: receiver, 
  package: package, 
   
  # Tipo de transporte: Aéreo (:air) ou rodoviário (:road)
  service_type: :road,
  
  # data/hora de coleta (Datetime obj.)
  shipping_in: 3.days.from_now.midday
  
})
```

O **retorno** é uma hash como esta abaixo:

```ruby
  {
    freight: 50.00,               # total do frete
    min_delivery_date: min_date,  # data mínima de entrega
    max_delivery_date: max_date   # data máxima de entrega
  }
```


#### 1.4.2 Consulta com retorno completo

É possível também pode realizar uma consulta completa com o método `Jamef.complete_rate`. 

Os parâmetros são idênticos aos da versão simplificada acima, o que muda é o retorno que agora é uma hash originada diretamente da resposta da Jamef.

**Exemplo de retorno:**

```ruby
{:freight=>
  {:msgerro=>"Ok - Calculo executado na filial [ CPQ ] cFilAnt : [03] Cliente Destinatario [  ] ",
   :valfre=>
    {:avalfre=>
      [{:componente=>"[01]-Pedagio             ", :imposto=>"0.58634409", :total=>"8.37634409", :valor=>"7.79000000"},
       {:componente=>"[03]-GRIS                ", :imposto=>"0.17583323", :total=>"2.51190323", :valor=>"2.33607000"},
       {:componente=>"[04]-TAS                 ", :imposto=>"0.49000000", :total=>"7.00000000", :valor=>"6.51000000"},
       {:componente=>"[05]-Taxa (ate 100kg)    ", :imposto=>"0.00000000", :total=>"0.00000000", :valor=>"0.00000000"},
       {:componente=>"[06]-Frete Peso (FM)     ", :imposto=>"13.81830288", :total=>"197.40432688", :valor=>"183.58602400"},
       {:componente=>"[07]-Frete Valor         ", :imposto=>"0.55680522", :total=>"7.95436022", :valor=>"7.39755500"},
       {:componente=>"[10]-TRT                 ", :imposto=>"0.00000000", :total=>"0.00000000", :valor=>"0.00000000"},
       {:componente=>"[23]-Frete Peso (FP)     ", :imposto=>"0.00000000", :total=>"0.00000000", :valor=>"0.00000000"},
       {:componente=>"[24]-Taxa (acima 100kg)  ", :imposto=>"0.00000000", :total=>"0.00000000", :valor=>"0.00000000"},
       {:componente=>"TF-TOTAL DO FRETE", :imposto=>"15.63000000", :total=>"223.25000000", :valor=>"207.62000000"}]}},
 :delivery=>{:cdtmax=>"03/05/18", :cdtmin=>"02/05/18", :msgerro=>"OK"}}
```

---

## 2. Rastreio (Tracking)

Ainda não está pronto.

---

## 3. Instalação

Se você estiver usando o Bundler, adiciona esta linha no seu Gemfile

```ruby
gem 'jamef-api', require: 'jamef'
```

E execute

    $ bundle

Ou instale diretamente no Ruby com

    $ gem install jamef-api

Neste caso, quando for utilizar, não esqueça de dar um

```ruby
require 'jamef-api'
```
    
em cima do documento antes utilizar a Gem.

---

## 4. Informações Complementares - Jamef

### 4.1 Tipo de Produto a ser enviado

Você pode especificar o tipo de produto transportado num pacote a partir da tabela abaixo.

##### 4.1.1 Para frete rodoviário​

| Ruby symbol | Tipo de produto |
| -------- | ------- |
| `:nf` | CONFORME NOTA FISCAL |
| `:livros` | LIVROS |

##### 4.1.2 Para frete aéreo

| Ruby symbol | Tipo de produto |
| -------- | ------- |
| `:nf` | CONFORME NOTA FISCAL |
| `:livros` | LIVROS |
| `:alimentos` | ALIMENTOS INDUSTRIALIZADOS |
| `:confeccoes` |  CONFECCOES |
| `:comesticos` |  COSMETICOS  |
| `:cirugicos` | MATERIAL CIRURGICO
| `:jornais` |  JORNAIS / REVISTAS |
| `material_escolar` |  MATERIAL ESCOLAR |


### 4.2 Filiais da Jamef

Encontre a sua filial e veja o valor do `jamef_branch` que você deve utilizar. Basicamente é o nome da cidade, mas por via das dúvidas:

**Filial Map:**

| Ruby symbol | Filial |
|---|---|
| `:aracaju` | AJU - Aracaju - SE |
| `:barueri` | BAR - Barueri - SP |
| `:bauru` | BAU - Bauru - SP |
| `:belo_horizonte` | BHZ - Belo Horizonte - MG |
| `:blumenau` | BNU - Blumenau - SC |
| `:brasilia` | BSB - Brasília - DF |
| `:criciuma` | CCM - Criciúma - SC |
| `:campinas` | CPQ - Campinas - SP |
| `:caxias_do_sul` | CXJ - Caxias do Sul - RS |
| `:curitiba` | CWB - Curitiba - PR |
| `:divinopolis` | DIV - Divinópolis - MG |
| `:feira_de_santana` | FES - Feira de Santana - BA |
| `:florianopolis` | FLN - Florianópolis - SC |
| `:fortaleza` | FOR - Fortaleza - CE |
| `:goiania` | GYN - Goiânia - GO |
| `:joao_pessoa` | JPA - João Pessoa - PB |
| `:juiz_de_fora` | JDF - Juiz de Fora - MG |
| `:joinville` | JOI - Joinville - SC |
| `:londrina` | LDB - Londrina - PR |
| `:manaus` | MAO - Manaus - AM |
| `:maceio` | MCZ - Maceió - AL |
| `:maringa` | MGF - Maringá - PR |
| `:porto_alegre` | POA - Porto Alegre - RS |
| `:pouso_alegre` | PSA - Pouso Alegre - MG |
| `:ribeirao_preto` | RAO - Ribeirão Preto - SP |
| `:recife` | REC - Recife - PE |
| `:rio_de_janeiro` | RIO - Rio de Janeiro - RJ |
| `:sao_paulo` | SAO - São Paulo - SP |
| `:sao_jose_dos_campos` | SJK - São José dos Campos - SP |
| `:sao_jose_do_rio_preto` | SJP - São José do Rio Preto - SP |
| `:salvador` | SSA - Salvador - BA |
| `:uberlandia` | UDI - Uberlândia - MG |
| `:vitoria_da_conquista` | VDC - Vitória da Conquista - BA |
| `:vitoria` | VIX - Vitória - ES |

---

## 5. Contribuições

Se vir um bug, manda aí.

Pull requests são super bem-vindos e serão aceitos desde que:

* Não sejam mirabolantes, 
* Incluam testes, 
* Façam sentido.

Tamo junto. :)

---

## 6. License

[MIT License](https://opensource.org/licenses/MIT).
