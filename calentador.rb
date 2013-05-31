require 'sinatra'
require 'bigdecimal'

get '/' do
  erb :index
end

get '/graficar' do
  @material = params[:id]

  case @material
  when 'cubo_telgopor'
    @coef_condicion_termica = 0.06
  when 'cubo_polietileno'
    @coef_condicion_termica = 0.023
  end

  @temp_inicial = Random.new.rand(0..30)
  @tiempo_calentamiento = BigDecimal.new(params[:tiempo])
  @resistencia = Random.new.rand((48.4*0.8)..(48.4*1.2))
  @calor_esp_agua = 1000
  @masa_agua = 1
  @voltaje = Random.new.rand((220*0.9)..(220*1.1))
  @sup_interfaz = 0.06
  @esp_interfaz = Random.new.rand((0.001 * 0.8)..(0.001 * 1.2))
  @temp_externa = Random.new.rand(-20..30)

  @corriente = @voltaje / @resistencia
  @watts = @voltaje ** 2 / @resistencia
  @calor_entregado = @watts / 4.184
  @joules = @calor_entregado / (@masa_agua * @calor_esp_agua)

  @temperaturas = []
  @temp_final = @temp_inicial
  @segundo = 1
  
  while @temp_final <= 1500

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
    @temp_externa += Random.new.rand(-0.03..0.07)
  end

  "#{@temperaturas}"

end

=begin
  radio cilindro: 5.419cm
  altura cilindro: 19.839 cm (2xradio)
  superficie: 0.04438 m**2
=end
