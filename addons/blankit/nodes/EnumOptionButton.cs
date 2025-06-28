using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

[GodotClassName("EnumOptionButton")]
public partial class EnumOptionButton : OptionButton {
	#region signals
	
	/// <summary>
	/// Signal that contains the integer value of the selected enum, such that it can be cast to the desired enum type.
	/// </summary>
	[Signal]
	public delegate void EnumSelectedEventHandler(int enumAsInt);
	
	#endregion
	
	#region variables

	/// <summary>
	/// a mapping of option button indexes to enum values.
	/// </summary>
	private Dictionary<long, int> mapping;

	#endregion
	
	#region Godot functions
	
	public override void _EnterTree() {
		this.mapping = new Dictionary<long, int>();
		this.ItemSelected += OnItemSelected;
	}
	
	public override void _ExitTree() {
		this.ItemSelected -= OnItemSelected;
	}
	
	#endregion
	
	#region EnumOptionButton functions

	/// <summary>
	/// populates the dropdown menu and mapping table for a given enum type.
	/// This is required to be called before the dropdown will function.
	/// </summary>
	/// <param name="enumType">An Enum type to select from the dropdown.</param>
	public void InitializeFor(Type enumType) {
		List<int> values = Enum.GetValues(enumType).Cast<int>().ToList();
		Array names = Enum.GetNames(enumType);
		for(int i = 0; i < values.Count; i++) {
			this.mapping.Add(mapping.Count, values[i]);
			this.AddItem((string)names.GetValue(i));
		}
	}

	/// <summary>
	/// Sets the currently selected value for the dropdown.
	/// </summary>
	/// <param name="enumValue">The value you want to select, cast to an int.</param>
	public void SetSelectedEnumValue(int enumValue) {
		foreach(int key in mapping.Keys) {
			if(mapping[key] == enumValue) {
				this.Selected = key;
				return;
			}
		}
	}

	private void OnItemSelected(long index) {
		//don't send signals if the mapping hasn't been created.
		if (mapping.Count == 0)
			return;
		
		EmitSignal(SignalName.EnumSelected, mapping[index]);
	}
	
	#endregion
}
