require 'sinatra'
require 'bigdecimal'

get '/' do
  erb :index
end

get '/graficar' do
  @temp_inicial = BigDecimal.new(params[:temp])
  @tiempo_calentamiento = BigDecimal.new(params[:tiempo])
  @resistencia = BigDecimal.new(params[:resistencia])
  @calor_esp_agua = 1000
  @masa_agua = 1
  @voltaje = 220
  @coef_condicion_termica = 0.04
  @sup_interfaz = 0.06
  @esp_interfaz = 0.001
  @temp_externa = 20

  @corriente = @voltaje / @resistencia
  @watts = @voltaje ** 2 / @resistencia
  @calor_entregado = @watts / 4.184
  @joules = @calor_entregado / (@masa_agua * @calor_esp_agua)

  @temperaturas = []
  @temperaturas << ["Segundos", "Temperatura"]
  @temp_final = @temp_inicial
  @segundo = 1
  
  while @temp_final <= 300

    #No calentar mas del tiempo ingresado
    if @segundo == @tiempo_calentamiento
      break
    end

    @temp_final = @joules + @temp_inicial
    @calor_perdido = (((@temp_final - @temp_externa) * @sup_interfaz) / @esp_interfaz) * @coef_condicion_termica
    @calor_final = @calor_entregado - (@calor_perdido / 4.184)
    @joules = @calor_final / (@masa_agua * @calor_esp_agua)
    @temp_final = @joules + @temp_inicial
    @temperaturas << [@segundo, @temp_final]
    @temp_inicial = @temp_final
    @segundo += 1
  end

  "#{@temperaturas}"

end

=begin
  radio cilindro: 5.419cm
  altura cilindro: 19.839 cm (2xradio)
  superficie: 0.04438 m**2
=end
