import { Socket, Presence } from 'phoenix'

let socket = new Socket('/socket', { params: { token: window.userToken } })

let roomId = window.roomId

let presences = {}

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

	channel.on('presence_state', (state) => {
		presences = Presence.syncState(presences, state)
		displayUsers(presences)
	})

	channel.on('presence_diff', (diff) => {
		presences = Presence.syncDiff(presences, diff)
		displayUsers(presences)
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

const displayUsers = (presences) => {
	let online = Presence.list(presences, (_id, { metas: [user, ...rest] }) => {
		return `<div id="user-${user.user_id}">${user.username}</div>`
	}).join('')
	document.querySelector('#users-online').innerHTML = online
}

export default socket
