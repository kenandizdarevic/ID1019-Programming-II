defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
    {:stick, stick}
  end

  # Recive the lock, remember that you gave away the lock -> statechange to gone()
  def available() do
    receive do
      {:request, from} ->
        :granted
        send(from, :granted)
        gone()
      :quit ->
        :ok
    end
  end

  # Assumes that the one who sends :return is a philosopher, can be tricked
  def gone() do
    receive do
      :return ->
        available()
      :quit ->
        :ok
    end
  end

  # If request is sent before release the request will wait in the queue
  def request({:stick, stick}) do
    send(stick, {:request, self()})
    receive do
      :granted ->
        :ok
    end
  end

  def return({:stick, stick}) do
    send(stick, :return)
  end

  def terminate({:stick, stick}) do
    send(stick, :quit)
  end

end
