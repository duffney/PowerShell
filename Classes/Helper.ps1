class Helper
{
    [HashTable] Splat([String[]] $Properties)
    {
        $splat = @{}

        foreach($prop in $Properties)
        {
            if($this.GetType().GetProperty($prop))
            {
                $splat.Add($prop, $this.$prop)
            }
        }

        return $splat
    }
}

class Concept : Helper
{
    [String] $Name
    [Int32] $Answer
    [Boolean] $HasTowel

    Concept ([String] $Name, [Int32] $Answer)
    {
        $this.Name = $Name
        $this.Answer = $Answer
    }
}

function Get-Meaning ($Name, $Answer)
{
    "The meaning of {0} is {1}." -f $Name, $Answer
}