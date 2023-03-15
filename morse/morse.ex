defmodule Morse do

  def test do
    table = encode_table()
    IO.puts("My name is #{encode('kenan', table, [])}")
    IO.puts("Decode for base: #{decode(base)}")
    IO.puts("Decode for rolled: #{decode(rolled)}")
  end

  def base do
    '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '
  end

  def rolled do
    '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
  end

  def encode_table() do
    map = for {char, code} <- codes, into: %{}, do: {char, code}
    Enum.into(map, %{})
  end

  def encode([], _, acc) do Enum.join(Enum.reverse(acc), " ") end
  def encode([char | tail], table, acc) do
    code = Map.get(table, char)
    encode(tail, table, [char | acc])
  end

  def decode(code) do
    decode(code, [], morse())
  end
  def decode([], acc, _) do
    Enum.reverse(acc)
  end
  def decode(code, acc, tree) do
    {char, tail} = decode_char(code, tree)
    decode(tail, Enum.concat([char], acc), tree)
  end

  def decode_char([], {:node, :na, _, _}) do
    {?*, []}
  end

  def decode_char([], {:node, char, _, _}) do
    {char, []}
  end

  def decode_char([?- | tail], {:node, _, long, _}) do
    decode_char(tail, long)
  end

  def decode_char([?. | tail], {:node, _, _, short}) do
    decode_char(tail, short)
  end
  def decode_char([?\s | tail], {:node, :na, _, _}) do
    {?*, tail}
  end

  def decode_char([?\s | tail], {:node, char, _, _}) do
    {char, tail}
  end

  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def codes do
    [{32, '..--'},
     {37,'.--.--'},
     {44,'--..--'},
     {45,'-....-'},
     {46,'.-.-.-'},
     {47,'.-----'},
     {48,'-----'},
     {49,'.----'},
     {50,'..---'},
     {51,'...--'},
     {52,'....-'},
     {53,'.....'},
     {54,'-....'},
     {55,'--...'},
     {56,'---..'},
     {57,'----.'},
     {58,'---...'},
     {61,'.----.'},
     {63,'..--..'},
     {64,'.--.-.'},
     {97,'.-'},
     {98,'-...'},
     {99,'-.-.'},
     {100,'-..'},
     {101,'.'},
     {102,'..-.'},
     {103,'--.'},
     {104,'....'},
     {105,'..'},
     {106,'.---'},
     {107,'-.-'},
     {108,'.-..'},
     {109,'--'},
     {110,'-.'},
     {111,'---'},
     {112,'.--.'},
     {113,'--.-'},
     {114,'.-.'},
     {115,'...'},
     {116,'-'},
     {117,'..-'},
     {118,'...-'},
     {119,'.--'},
     {120,'-..-'},
     {121,'-.--'},
     {122,'--..'}]
  end

end
