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
        setResponse("")
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
            const result = await response.text()
            setResponse(result)
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
            <div style={{ width: "100%" }}>
                <input 
                    style={{
                        width: "calc(100% - 32px)", // full width minus left/right margins
                        margin: "0 16px",           // 16px margin on left/right
                        boxSizing: "border-box",    // ensures padding/border don’t break layout
                    }}
                    placeholder="Type here..."
                    value={userInput} 
                    onChange={e => setUserInput(e.target.value)}
                />
            </div>
            
            {loading && <p>loading...</p>}
            <div style={{
                margin: "20px 0"
            }}
            >
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