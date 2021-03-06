import { Socket, Presence } from 'phoenix'

let socket = new Socket('/socket', { params: { token: window.userToken } })

let roomId = window.roomId

let presences = {}

if (window.userToken) {
	socket.connect()
}

if (roomId) {
	const timeout = 1500
	var typingTimer
	let isUserTyping = false

	let channel = socket.channel(`room:${roomId}`, {})

	channel
		.join()
		.receive('ok', (resp) => {
			console.log('Joined successfully', resp)
			resp.messages.reverse().map((msg) => displayMessage(msg))
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

	document.querySelector('#message-body').addEventListener('keydown', () => {
		startTyping()
		clearTimeout(typingTimer)
	})
	document.querySelector('#message-body').addEventListener('keyup', () => {
		clearTimeout(typingTimer)
		typingTimer = setTimeout(stopTyping, timeout)
	})

	const startTyping = () => {
		if (isUserTyping) return
		isUserTyping = true
		channel.push('user:typing', { typing: true })
	}

	const stopTyping = () => {
		clearTimeout(typingTimer)
		isUserTyping = false
		channel.push('user:typing', { typing: false })
	}

	const displayMessage = (msg) => {
		let template = `<li>
		<strong>${msg.user.username}: </strong>
		${msg.body}
		</li>`

		document.querySelector('#display').innerHTML += template
	}
}

const displayUsers = (presences) => {
	let online = Presence.list(presences, (_id, { metas: [user, ...rest] }) => {
		let typingTemplate = ''

		if (user.typing) {
			typingTemplate = `<i class="far fa-keyboard text-red-700 animate-ping ml-4"></i>`
		}

		return `<li id="user-${user.user_id}" class="p-2 flex justify-start items-center rounded-md my-3 shadow-lg bg-gray-200">
							<span class="font-light tracking-wider">${user.username}</span>
																		${typingTemplate}
		        </li>`
	}).join('')
	document.querySelector('#users-online').innerHTML = online
}

export default socket
