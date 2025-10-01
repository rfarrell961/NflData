import { useState } from "react"

function MainScreen()
{
    const [userInput, setUserInput] = useState("")
    const [response, setResponse] = useState("")
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)

    const SendRequest = async () => {
        setLoading(true)
        setError(null)
        try
        {
            const response = await fetch("https://localhost:7173/api/Query", {
                method: "POST",
                headers: {
                    "Content-Type" : "application/json"
                },
                body: "\"" + userInput + "\""
            })

            if (!response.ok) throw new Error ("Network Error")
            const json = await response.json()
            console.log(json)
        }
        catch(err)
        {
            console.log(err)
            setError(err.message)
        }
        finally
        {
            setLoading(false)
        }
    }

    return (
        <>
            <p>
                {response}
            </p>
            <input 
                value={userInput} 
                onChange={e => setUserInput(e.target.value)}
            />
            {loading && <p>loading...</p>}
            <div>
                <button onClick={SendRequest}>
                    Enter
                </button>
            </div>
            {(error != null) && <div>
                <p>{error}</p>
            </div>}
        </>
    )
}

export default MainScreen;