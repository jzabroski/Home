using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Globalization;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(
Format.Native,
IsByteOrdered = true,
ValidationMethodName = “ValidateIntervalCID”)]
public struct IntervalCID : INullable
{
    //Regular expression used to parse values of the form (intBegin,intEnd)
    private static readonly Regex _parser
        = new Regex
                (@”A(s*(?<intBegin>-?d+?)s*:s*(?<intEnd>-?d+?)s*)Z”,
            RegexOptions.Compiled | RegexOptions.ExplicitCapture);

    // Begin, end of interval
    private Int32 _begin;
    private Int32 _end;

    // Internal member to show whether the value is null
    private bool _isnull;

    // Null value returned equal for all instances
    private const string NULL = “<<null interval>>”;
    private static readonly IntervalCID NULL_INSTANCE
    = new IntervalCID(true);

    // Constructor for a known value
    public IntervalCID(Int32 begin, Int32 end)
    {
        this._begin = begin;
        this._end = end;
        this._isnull = false;
    }

    // Constructor for an unknown value
    private IntervalCID(bool isnull)
    {
        this._isnull = isnull;
        this._begin = this._end = 0;
    }

    // Default string representation
    public override string ToString()
    {
        return this._isnull ? NULL : (“(“
        + this._begin.ToString(CultureInfo.InvariantCulture) + “:”
        + this._end.ToString(CultureInfo.InvariantCulture)
        + “)”);
    }

    // Null handling
    public bool IsNull
    {
        get
        {
            return this._isnull;
        }
    }

    public static IntervalCID Null
    {
        get
        {
            return NULL_INSTANCE;
        }
    }

    // Parsing input using regular expression
    public static IntervalCID Parse(SqlString sqlString)
    {
        string value = sqlString.ToString();

        if (sqlString.IsNull || value == NULL)
            return new IntervalCID(true);

        // Check whether the input value matches the regex pattern
        Match m = _parser.Match(value);

        // If the input’s format is incorrect, throw an exception
        if (!m.Success)
            throw new ArgumentException(
                “Invalid format for complex number. “
                + “Format is (intBegin:intEnd).”);

        // If everything is OK, parse the value; 
        // we will get two Int32 type values
        IntervalCID it = new IntervalCID(Int32.Parse(m.Groups[1].Value,
            CultureInfo.InvariantCulture), Int32.Parse(m.Groups[2].Value,
            CultureInfo.InvariantCulture));
        if (!it.ValidateIntervalCID())
            throw new ArgumentException(“Invalid begin and end values.”);

        return it;
    }

    // Begin and end separately
    public Int32 BeginInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            return this._begin;
        }
        set
        {
            Int32 temp = _begin;
            _begin = value;
            if (!ValidateIntervalCID())
            {
                _begin = temp;
                throw new ArgumentException(“Invalid begin value.”);
            }
        }
    }

    public Int32 EndInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            return this._end;
        }
        set
        {
            Int32 temp = _end;
            _end = value;
            if (!ValidateIntervalCID())
            {
            _end = temp;
            throw new ArgumentException(“Invalid end value.”);
            }
        }
    }

    // Validation method
    private bool ValidateIntervalCID()
    {
        if (_end >= _begin)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // Allen’s operators
    public bool Equals(IntervalCID target)
    {
        return ((this._begin == target._begin) &
            (this._end == target._end));
    }

    public bool Before(IntervalCID target)
    {
        return (this._end < target._begin);
    }

    public bool After(IntervalCID target)
    {
        return (this._begin > target._end);
    }

    public bool Includes(IntervalCID target)
    {
        return ((this._begin <= target._begin) &
                (this._end >= target._end));
    }

    public bool ProperlyIncludes(IntervalCID target)
    {
        return ((this._begin < target._begin) &
                (this._end > target._end));
    }

    public bool Meets(IntervalCID target)
    {
        return ((this._end + 1 == target._begin) |
                (this._begin == target._end + 1));
    }

    public bool Overlaps(IntervalCID target)
    {
        return ((this._begin <= target._end) &
                (target._begin <= this._end));
    }

    public bool Merges(IntervalCID target)
    {
        return (this.Meets(target) |
                this.Overlaps(target));
    }

    public bool Begins(IntervalCID target)
    {
        return ((this._begin == target._begin) &
                (this._end <= target._end));
    }

    public bool Ends(IntervalCID target)
    {
        return ((this._begin >= target._begin) &
                (this._end == target._end));
    }

    public IntervalCID Union(IntervalCID target)
    {
        if (this.Merges(target))
            return new IntervalCID(
                    System.Math.Min(this.BeginInt, target.BeginInt),
                    System.Math.Max(this.EndInt, target.EndInt));
        else
            return new IntervalCID(true);
    }

    public IntervalCID Intersect(IntervalCID target)
    {
        if (this.Merges(target))
            return new IntervalCID(
                    System.Math.Max(this.BeginInt, target.BeginInt),
                    System.Math.Min(this.EndInt, target.EndInt));
        else
            return new IntervalCID(true);
    }

    public IntervalCID Minus(IntervalCID target)
    {
        if (this.Merges(target) &
                (this.BeginInt < target.BeginInt) & 
                (this.EndInt <= target.EndInt))
            return new IntervalCID(
                    this.BeginInt, 
                    System.Math.Min(target.BeginInt – 1, this.EndInt));
        else
        if (this.Merges(target) &
                    (this.BeginInt >= target.BeginInt) & 
                    (this.EndInt > target.EndInt))
            return new IntervalCID(
                        System.Math.Max(target.EndInt + 1, this.BeginInt), 
                        this.EndInt);
        else
            return new IntervalCID(true);
    }
}
