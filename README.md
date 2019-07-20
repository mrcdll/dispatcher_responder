# Device Gateway

## Description
This service collects messages from different devices (in this case browser tabs) and dispatches them in a parallelized fashion. The Gateway allows massive firmware updates.

## Features
* Stateful connection between devices and the Gateway
* State recovery in the case of disconnection
* In memory queue
* Buffered dispatching pipeline
* Dynamic workers


## How to run the service locally

* Clone the repo `git clone git@github.com:mrcdll device-gateway.git`
* And cd into it `cd device-gateway`

With Docker Compose

1. Make sure to have Docker desktop installed and running https://www.docker.com/products/docker-desktop
2. `git clone git@github.com:mrcdll/device-gateway.git`
3. `docker-compose up --build`


On your local machine
1. Install elixir 1.9.0 with Kiex https://github.com/taylor/kiex or alternatively if you use Asdf https://github.com/asdf-vm/asdf the .tool-versions file will setup the right version for you
2. `mix deps.get`
3. `cd assets && npm i`


## How it works

On your browser (preferably Chrome) visit `localhost.com:4000/any_device_identifier` e.g `localhost.com:4000/marco` or `localhost.com:4000/fridge`
When the the browser hits the endpoint a few things happen:
* A websocket connection is established
* The device subscribes to the server Pub/Sub
* The device fetches it's one state (the number of messages sent previously)
* The server fetches the list of all messages received.

(For convenience in each browser tab you will see both the logged device and the Device Gateway server)
`lib/firmware_updater_web/live/control_panel_view.ex`

```
def mount(session, socket) do
    device_name = session.device_name

    if connected?(socket) do
      DeviceHub.subscribe_to_server()
    end

    {:ok,
     assign(socket, %{
       device_name: device_name,
       messages_sent: DeviceHub.messages_sent(DefaultHub, device_name),
       server_state: FirmwareUpdater.ServerState.fetch(DefaultServerState),
       firmware_updates: []
     })}
  end
```

Clicking the button `SEND MESSAGE` you will mimic an incoming message from the device and it will trigger a dispatch pipeline:
1. The message is stored in a queue `lib/firmware_updater/queue.ex`.  The queue in this prototype is a simple process, holding the state by recursively returning the state as a parameter. This is called GenServer https://hexdocs.pm/elixir/GenServer.html
2. Another smarter GenServer called GenStage fetches data from the queue based on how many fetching request it receives. If there is nothing to fetch it sends a message to itself to try again in 2 seconds. `lib/firmware_updater/gen_stage/queue_fetcher.ex`
3. A GenStage is smart because it allows other processes to subscribe to it and request events. In our case our subscriber is also a process supervisor `lib/firmware_updater/gen_stage/kafka_dispatcher_supervisor.ex` which requests some events from the Queue Fetcher then spawns n process workers based on the number of events received. (The value is hard coded in this prototype, but eventually it will be set as ENV or dynamically based on different variables, such as network RPM)
4. The process worker dispatch the message back to the view for us to display or it could be sent to other services `lib/firmware_updater/gen_stage/kafka_dispatcher.ex` a process worker automatically dies after sending its message.

As a result of this process you will see the message sent into the server log and the process PID which dispatched the message.

Clicking the button `UPDATE DEVICE`  will notify and push a firmware update to all connected devices.

Closing the tab and reopening it would retain the number of messages sent. The same thing could be done with fetching the latest firmware upgrade (I've skipped that part due to the redundant logic proof of concept).

I would also suggest to try with different tabs (and device names) opened simultaneously.

