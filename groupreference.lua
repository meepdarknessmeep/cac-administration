local self = {}
CAC.GroupReference = CAC.MakeConstructor (self, CAC.Serialization.ISerializable)

function self:ctor (groupSystemId, groupId)
	self.GroupSystem   = nil
	self.GroupSystemId = groupSystemId
	self.GroupId       = groupId
end

-- ISerializable
function self:Serialize (outBuffer)
	outBuffer:StringN8 (self.GroupSystemId)
	outBuffer:StringN8 (self.GroupId      )
end

function self:Deserialize (inBuffer)
	self:SetGroupSystemId (inBuffer:StringN8 ())
	self:SetGroupId       (inBuffer:StringN8 ())
end

function self:Clone (clone)
	clone = clone or CAC.GroupReference ()
	
	clone:SetGroupSystemId (self:GetGroupSystemId ())
	clone:SetGroupId       (self:GetGroupId       ())
	
	return clone
end

function self:Copy (source)
	self:SetGroupSystemId (source:GetGroupSystemId ())
	self:SetGroupId       (source:GetGroupId       ())
	
	return self
end

-- Membership
function self:ContainsUser (userId)
	return self:GetGroupSystem ():IsUserInGroup (userId, self.GroupId)
end

function self:MatchesUser (userId)
	return self:ContainsUser (userId)
end

-- GroupReference
function self:GetDisplayName ()
	if self:GetGroupSystem () then
		return self:GetGroupSystem ():GetName () .. " : "  .. self.GroupId
	else
		return self.GroupSystemId .. " : " .. self.GroupId
	end
end

function self:GetGroupDisplayName (fallback)
	if not self:GetGroupSystem () then return fallback end
	
	return self:GetGroupSystem ():GetGroupDisplayName (self.GroupId) or fallback
end

function self:GetGroupIcon (fallback)
	if not self:GetGroupSystem () then return fallback end
	
	return self:GetGroupSystem ():GetGroupIcon (self.GroupId) or fallback
end

function self:GetGroupSystem ()
	if not self.GroupSystem then
		self.GroupSystem = CAC.SystemRegistry:GetSystem ("GroupSystem", self.GroupSystemId)
	end
	
	return self.GroupSystem
end

function self:SetGroupSystem (groupSystem)
	if self.GroupSystem == groupSystem then return self end
	
	self.GroupSystem = groupSystem
	self:SetGroupSystemId (groupSystem:GetId ())
	
	return self
end

function self:GetGroupSystemId ()
	return self.GroupSystemId
end

function self:SetGroupSystemId (groupSystemId)
	if self.GroupSystemId == groupSystemId then return self end
	
	self.GroupSystemId = groupSystemId
	
	if self.GroupSystem and
	   self.GroupSystem:GetId () ~= self.GroupSystemId then
		self.GroupSystem = nil
	end
	
	return self
end

function self:GetGroupId ()
	return self.GroupId
end

function self:SetGroupId (groupId)
	if self.GroupId == groupId then return self end
	
	self.GroupId = groupId
	
	return self
end

function self:ToString ()
	return self.GroupSystemId .. "/" .. self.GroupId
end