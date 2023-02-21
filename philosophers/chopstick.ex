defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
    {:stick, stick}
  end

  def available() do
    receive do
      {:request, from} ->
        :granted
        gone()
      :quit ->
        :ok
    end

  end

  def gone() do
    receive do
      :return ->
        available()
      :quit ->
        :ok
    end
  end

  def request(stick) do
    send(stick, self())
    receive do
      :granted ->
        :ok
    end
  end

  def return(stick) do
    send(stick, :return)
  end

  def terminate(stick) do
    send(stick, :quit)
  end

end
