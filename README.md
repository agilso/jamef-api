# Jamef API (v1)

Olá. Essa gem é um Ruby wrapper da API SOAP (v1) da *Jamef.com.br*. Use-a em qualquer projeto Ruby/Rails.

Você poderá facilmente

* **Consultar** frete e prazo de entrega
* **Rastrear** encomendas despachadas **( ! )**

**( ! )** Neste momento, somente a consulta está disponível. A funcionalidade do rastreio (tracking) não deve demorar para ser implementada. Colaborações são bem-vindas, mande o pull-request. ;)

## Guia de utilização

Vamos aprender a **consultar valor e prazo**  e também **rastrear uma encomenda**.

### Consulta de frete (Rating)

São apenas 3 passos para realizar uma consulta.

**1)** Inicialize um objeto `Jamef::Client` com as informações da sua empresa.

```ruby
my_company = Jamef::Client.new({
  document: 'xxx',          # cpf ou cnpj
  user: 'xxx',              # usuario jamef
  city: 'Jundiaí',          # sua cidade
  state: 'SP',              # seu estado
  jamef_branch: :campinas   # sua filial da jamef
})
```                           

**Importante:**

* O valor do `user` é nome do seu usuário no portal da http://jamef.com.br 
* `jamef_branch` é sempre o nome da cidade da filial da Jamef associada à sua conta. Veja a tabela no final do documento.

---

**2)** Crie um pacote informando o volume final cubado (**m³**) e também seu peso (**kg**) com o `Jamef::Package`.

```ruby
package = Jamef::Package.new({
  weight: 5,            # kg - peso da encomenda
  package_price: 1000,  # R$ - valor da encomenda
  volume: 5,            # m³ - vol. total cubado
  type: :nf             # opcional (leia abaixo)
}) 
```

Este último parâmetro `type` está relacionado com o tipo de produto que será transportado. 

Você pode omitir `type: :nf` que é o valor padrão. O tipo `:nf` diz à Jamef para inferir o tipo de produto a partir da nota fiscal. Veja a tabela no final do documento para preencher o campo `type` adequadamente.

---

**3)** Realize a consulta.

```ruby
Jamef.rate({
  client: my_company, 
  package: package, 
  
  # CEP
  to: 'xxxxx-xxx',
   
  # Tipo de transporte: Aéreo (:air) ou rodoviário (:road)
  service_type: :road,
  
  # data de coleta
  shipping_in: 3.days.from_now
  
})
# => {price: 50.00, estimated_delivery_date: date }
```

Em `shipping_in`, informe a data em que a encomenda deverá ser despachada.

E é isso. ;)

---

### Rastreio (Tracking)

Ainda não está pronto.

---

## Instalação

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

## Informações Complementares - Jamef

### Tipo de Produto a ser enviado

Você pode especificar o tipo de produto transportado num pacote a partir da tabela abaixo.

##### Para frete rodoviário​

| Ruby symbol | Tipo de produto |
| -------- | ------- |
| `:nf` | CONFORME NOTA FISCAL |
| `:livros` | LIVROS |

##### Para frete aéreo

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


### Filiais da Jamef

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


## Contribuições

Se vir um bug, manda aí.

Pull requests são super bem-vindos e serão aceitos desde que:

* Não sejam mirabolantes, 
* Incluam testes, 
* Façam sentido.


Tamo junto. :)

## License

[MIT License](https://opensource.org/licenses/MIT).
