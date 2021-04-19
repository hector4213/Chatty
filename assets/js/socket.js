import { Socket } from 'phoenix'

let socket = new Socket('/socket', { params: { token: window.userToken } })

let roomId = window.roomId

socket.connect()

if (roomId) {
	let channel = socket.channel(`room:${roomId}`, {})
	channel
		.join()
		.receive('ok', (resp) => {
			console.log('Joined successfully', resp)
		})
		.receive('error', (resp) => {
			console.log('Unable to join', resp)
		})

	channel.on(`room:${roomId}:new_message`, (message) => {
		displayMessage(message)
	})

	document.querySelector('#message-form').addEventListener('submit', (e) => {
		e.preventDefault()
		let input = e.target.querySelector('#message-body')
		channel.push('message:add', { message: input.value })
		input.value = ''
	})

	const displayMessage = (msg) => {
		let template = `<li>
		<strong>${msg.user.username}</strong>
		${msg.body}
		</li>`

		document.querySelector('#display').innerHTML += template
	}
}

export default socket
