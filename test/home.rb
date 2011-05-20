require File.expand_path("../site", File.dirname(__FILE__))
require "cuba/test"

scope do
  test "Homepage" do
    visit "/"

    assert has_content?("Esta es la API del Censo Argentino 2010")

    click_link "Raw Data"

    assert has_content?('{"DEPARTAMTO":"SAN NICOLAS"')

    visit "/"

    click_link "Personas por Vivienda"

    assert has_content?('"PERSONAS_POR_VIVIENDA":2.929014763482977')
  end
end
